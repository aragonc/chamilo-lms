<?php

/* For licensing terms, see /license.txt */

require_once __DIR__.'/../inc/global.inc.php';
$current_course_tool = TOOL_GRADEBOOK;

if (!api_is_student_boss()) {
    api_protect_course_script(true);
}

api_block_anonymous_users();

if (!api_is_allowed_to_edit() && !api_is_student_boss()) {
    api_not_allowed(true);
}

api_set_more_memory_and_time_limits();

//extra javascript functions for in html head:
$htmlHeadXtra[] = "<script>
function confirmation() {
	if (confirm(\" ".trim(get_lang('AreYouSureToDelete'))." ?\")) {
	    return true;
	} else {
	    return false;
	}
}
</script>";

$categoryId = isset($_GET['cat_id']) ? (int) $_GET['cat_id'] : 0;
$action = isset($_GET['action']) && $_GET['action'] ? $_GET['action'] : null;
$filterOfficialCode = isset($_POST['filter']) ? Security::remove_XSS($_POST['filter']) : null;
$filterOfficialCodeGet = isset($_GET['filter']) ? Security::remove_XSS($_GET['filter']) : null;

// Orden de la lista: por nombre (por defecto) o por fecha de emisión asc/desc
$sortCertificates = isset($_GET['sort']) ? $_GET['sort'] : 'name';
if (!in_array($sortCertificates, ['name', 'date_asc', 'date_desc'])) {
    $sortCertificates = 'name';
}

$url = api_get_self().'?'.api_get_cidreq().'&cat_id='.$categoryId.'&filter='.$filterOfficialCode.'&sort='.$sortCertificates;
$courseInfo = api_get_course_info();

$filter = api_get_setting('certificate_filter_by_official_code');
$userList = [];
$filterForm = null;
$certificate_list = [];
if ($filter === 'true') {
    $options = UserManager::getOfficialCodeGrouped();
    $options = array_merge(['all' => get_lang('All')], $options);
    $form = new FormValidator(
        'official_code_filter',
        'POST',
        api_get_self().'?'.api_get_cidreq().'&cat_id='.$categoryId
    );
    $form->addElement('select', 'filter', get_lang('OfficialCode'), $options);
    $form->addButton('submit', get_lang('Submit'));
    $filterForm = '<br />'.$form->returnForm();

    if ($form->validate()) {
        $officialCode = $form->getSubmitValue('filter');
        if ($officialCode === 'all') {
            $certificate_list = GradebookUtils::get_list_users_certificates($categoryId, [], $sortCertificates);
        } else {
            $userList = UserManager::getUsersByOfficialCode($officialCode);
            if (!empty($userList)) {
                $certificate_list = GradebookUtils::get_list_users_certificates(
                    $categoryId,
                    $userList,
                    $sortCertificates
                );
            }
        }
    } else {
        $certificate_list = GradebookUtils::get_list_users_certificates($categoryId, [], $sortCertificates);
    }
} else {
    $certificate_list = GradebookUtils::get_list_users_certificates($categoryId, [], $sortCertificates);
}

$content = '';
$courseCode = api_get_course_id();
$allowCustomCertificate = api_get_plugin_setting('customcertificate', 'enable_plugin_customcertificate') === 'true' &&
    api_get_course_setting('customcertificate_course_enable', $courseInfo) == 1;

$allowEasyCertificate = api_get_plugin_setting('easycertificate', 'enable_plugin_easycertificate') === 'true' &&
    api_get_course_setting('easycertificate_course_enable', $courseInfo) == 1;

$tags = Certificate::notificationTags();

switch ($action) {
    case 'send_notifications':
        $currentUserInfo = api_get_user_info();
        $message = isset($_POST['message']) ? $_POST['message'] : '';
        $subject = get_lang('NotificationCertificateSubject');
        if (!empty($message)) {
            foreach ($certificate_list as $index => $value) {
                $userInfo = api_get_user_info($value['user_id']);
                if (empty($userInfo)) {
                    continue;
                }
                $list = GradebookUtils::get_list_gradebook_certificates_by_user_id(
                    $value['user_id'],
                    $categoryId
                );

                foreach ($list as $valueCertificate) {
                    Certificate::sendNotification(
                        $subject,
                        $message,
                        $userInfo,
                        $courseInfo,
                        $valueCertificate
                    );
                }
            }
            Display::addFlash(Display::return_message(get_lang('Sent')));
        }

        header('Location: '.$url);
        exit;
        break;
    case 'show_notification_form':
        $form = new FormValidator('notification', 'post', $url.'&action=send_notifications');
        $form->addHeader(get_lang('SendNotification'));
        $form->addHtmlEditor('message', get_lang('Message'));
        $form->addLabel(
            get_lang('Tags'),
            Display::return_message(implode('<br />', $tags), 'normal', false)
        );
        $form->addButtonSend(get_lang('Send'));
        $form->setDefaults(
            ['message' => nl2br(get_lang('NotificationCertificateTemplate'))]
        );
        $content = $form->returnForm();
        break;
    case 'export_all_certificates_zip':
        $params = 'course_code='.api_get_course_id().
            '&session_id='.api_get_session_id().
            '&'.api_get_cidreq().
            '&cat_id='.$categoryId;

        if ($allowCustomCertificate) {
            $url = api_get_path(WEB_PLUGIN_PATH).'customcertificate/src/print_certificate.php?export_all=1&'.$params;
        }
        if ($allowEasyCertificate) {
            $url = api_get_path(WEB_PLUGIN_PATH).'easycertificate/src/print_certificate.php?export_all=1&'.$params;
        }

        header('Location: '.$url);

        exit;
    case 'generate_all_certificates':

        $plugin = ProikosPlugin::create();
        $session_id = api_get_session_id();

        // Fecha personalizada opcional (formato local 'Y-m-d H:i:s') enviada
        // desde el modal; si no llega o es inválida se usa el comportamiento actual.
        $customDate = null;
        if (!empty($_GET['custom_date'])) {
            $dateCheck = DateTime::createFromFormat('Y-m-d H:i:s', $_GET['custom_date']);
            if (false !== $dateCheck) {
                $customDate = $dateCheck->format('Y-m-d H:i:s');
            }
        }

        // Envío de correo de notificación: activado salvo que el modal mande send_mail=0
        $sendCertificateEmail = !(isset($_GET['send_mail']) && $_GET['send_mail'] === '0');

        $userList = CourseManager::get_user_list_from_course_code(
            api_get_course_id(),
            $session_id
        );
        $course_id = api_get_course_int_id(api_get_course_id());

        $generatedCount = 0;
        $alreadyHadCount = 0;
        $notEligibleCount = 0;
        $notEligibleDetails = [];

        $categoryData = Category::load($categoryId);
        $categoryObject = !empty($categoryData[0]) ? $categoryData[0] : null;

        if (!empty($userList)) {
            foreach ($userList as $userInfo) {
                if ($userInfo['status'] == INVITEE) {
                    continue;
                }

                // Si el usuario ya tiene certificado, se salta antes de todo el
                // cálculo pesado (gradebook, quizzes, correo): una sola consulta.
                $existingCertificate = GradebookUtils::get_certificate_by_user_id(
                    $categoryId,
                    $userInfo['user_id']
                );
                if (!empty($existingCertificate)) {
                    $alreadyHadCount++;
                    continue;
                }

                $params = $plugin->getValuesRegisterData($userInfo['user_id'], $course_id, $session_id);
                $checkRegister = $plugin->checkRegisterLogData($userInfo['user_id'], $course_id, $session_id);

                if($checkRegister == 0){
                    $plugin->registerData($params, true);
                }
                $result = Category::generateUserCertificate(
                    $categoryId,
                    $userInfo['user_id'],
                    false,
                    false,
                    $customDate,
                    $sendCertificateEmail
                );

                if (false === $result || null === $result) {
                    // No terminó el curso, no aprobó todos los quizzes o no
                    // alcanza el puntaje mínimo. Se detalla el motivo por
                    // estudiante para poder diagnosticar casos puntuales.
                    $notEligibleCount++;

                    $reasons = [];
                    if (null !== $categoryObject) {
                        $currentScore = Category::getCurrentScore(
                            $userInfo['user_id'],
                            $categoryObject,
                            true
                        );
                        $minScore = $categoryObject->getCertificateMinScore();
                        if ($currentScore < $minScore) {
                            $reasons[] = 'puntaje '.round($currentScore, 2).'% (mínimo '.$minScore.'%)';
                        }
                        if (empty($categoryObject->getGenerateCertificates())) {
                            $reasons[] = 'la evaluación no tiene activada la generación de certificados';
                        }
                    }
                    $quizCheckDetail = ProikosPlugin::checkUserQuizCompletion(
                        $userInfo['user_id'],
                        $categoryId
                    );
                    if (empty($quizCheckDetail['passed'])) {
                        $pendingTitles = [];
                        if (!empty($quizCheckDetail['incomplete_quizzes'])) {
                            foreach ($quizCheckDetail['incomplete_quizzes'] as $pendingQuiz) {
                                $pendingTitles[] = $pendingQuiz['title'];
                            }
                        }
                        $reasons[] = 'quizzes pendientes'.(!empty($pendingTitles) ? ': '.implode(', ', $pendingTitles) : '');
                    }
                    if (empty($reasons)) {
                        $reasons[] = 'motivo no determinado';
                    }

                    $notEligibleDetails[] = api_get_person_name(
                        $userInfo['firstname'],
                        $userInfo['lastname']
                    ).' — '.implode('; ', $reasons);
                } else {
                    $generatedCount++;
                }
            }
        }

        $messageParts = [];
        if ($generatedCount > 0) {
            $messageParts[] = 1 == $generatedCount
                ? 'Se generó 1 certificado.'
                : "Se generaron $generatedCount certificados.";
            if (!empty($customDate)) {
                $messageParts[] = 'Fecha de emisión personalizada: '.api_format_date($customDate, DATE_TIME_FORMAT_LONG).'.';
            }
            if (!$sendCertificateEmail) {
                $messageParts[] = 'No se enviaron correos de notificación.';
            }
        } else {
            $messageParts[] = 'No se generó ningún certificado.';
        }
        if ($alreadyHadCount > 0) {
            $messageParts[] = 1 == $alreadyHadCount
                ? '1 estudiante ya tenía certificado.'
                : "$alreadyHadCount estudiantes ya tenían certificado.";
        }
        if ($notEligibleCount > 0) {
            $messageParts[] = 1 == $notEligibleCount
                ? '1 estudiante aún no cumple los requisitos (curso no finalizado, quizzes pendientes o puntaje insuficiente).'
                : "$notEligibleCount estudiantes aún no cumplen los requisitos (curso no finalizado, quizzes pendientes o puntaje insuficiente).";
            if (!empty($notEligibleDetails)) {
                $messageParts[] = '<br /><strong>Detalle:</strong><br />'.implode('<br />', array_map('htmlspecialchars', $notEligibleDetails));
            }
        }

        Display::addFlash(
            Display::return_message(
                implode(' ', $messageParts),
                $generatedCount > 0 ? 'confirmation' : 'warning',
                false
            )
        );

        header('Location: '.$url);
        exit;

    case 'delete_all_certificates':
        Category::deleteAllCertificates($categoryId);
        Display::addFlash(Display::return_message(get_lang('Deleted')));
        header('Location: '.$url);
        exit;
        break;
    case 'download_all_certificates':
        $courseCode = api_get_course_id();
        $sessionId = api_get_session_id();
        $categoryId = (int) $_GET['catId'];
        $date = api_get_utc_datetime(null, false, true);
        $pdfName = 'certs_'.$courseCode.'_'.$sessionId.'_'.$categoryId.'_'.$date->format('Y-m-d');
        $finalFile = api_get_path(SYS_ARCHIVE_PATH)."$pdfName.pdf";

        $result = DocumentManager::file_send_for_download($finalFile, true);
        if (false === $result) {
            api_not_allowed(true);
        }
        break;
    case 'download_certificates_report':
        $exportData = array_map(function ($learner) {
            return [
                $learner['user_id'],
                $learner['username'],
                $learner['firstname'],
                $learner['lastname'],
            ];
        }, $certificate_list);

        $csvContent = [];
        $csvHeaders = [];
        $csvHeaders[] = get_lang('Id');
        $csvHeaders[] = get_lang('UserName');
        $csvHeaders[] = get_lang('FirstName');
        $csvHeaders[] = get_lang('LastName');
        $csvHeaders[] = get_lang('Score');
        $csvHeaders[] = get_lang('Date');

        $extraFields = [];
        $extraFieldsFromSettings = [];
        $extraFieldsFromSettings = api_get_configuration_value('certificate_export_report_user_extra_fields');

        if (!empty($extraFieldsFromSettings) && isset($extraFieldsFromSettings['extra_fields'])) {
            $extraFields = $extraFieldsFromSettings['extra_fields'];
            $usersProfileInfo = [];

            $userIds = array_column($certificate_list, 'user_id', 'user_id');

            foreach ($extraFields as $fieldName) {
                $extraFieldInfo = UserManager::get_extra_field_information_by_name($fieldName);

                if (!empty($extraFieldInfo)) {
                    $csvHeaders[] = $fieldName;

                    $usersProfileInfo[$extraFieldInfo['id']] = TrackingCourseLog::getAdditionalProfileInformationOfFieldByUser(
                        $extraFieldInfo['id'],
                        $userIds
                    );
                }
            }

            foreach ($exportData as $key => $row) {
                $list = GradebookUtils::get_list_gradebook_certificates_by_user_id(
                    $row[0],
                    $categoryId
                );

                foreach ($list as $valueCertificate) {
                    $row[] = $valueCertificate['score_certificate'];
                    $row[] = api_convert_and_format_date($valueCertificate['created_at']);
                }

                foreach ($usersProfileInfo as $extraInfo) {
                    $row[] = $extraInfo[$row[0]][0];
                }

                $csvContent[] = $row;
            }
        }

        array_unshift($csvContent, $csvHeaders);

        $fileName = 'learner_certificate_report_'.api_get_local_time();
        Export::arrayToCsv($csvContent, $fileName);
        break;
}

$interbreadcrumb[] = [
    'url' => Category::getUrl(),
    'name' => get_lang('Gradebook'),
];
$interbreadcrumb[] = ['url' => '#', 'name' => get_lang('GradebookListOfStudentsCertificates')];

$this_section = SECTION_COURSES;
Display::display_header('');

if ($action === 'delete') {
    $check = Security::check_token('get');
    if ($check) {
        $certificate = new Certificate($_GET['certificate_id']);
        $result = $certificate->delete(true);
        Security::clear_token();
        if ($result == true) {
            echo Display::return_message(get_lang('CertificateRemoved'), 'confirmation');
        } else {
            echo Display::return_message(get_lang('CertificateNotRemoved'), 'error');
        }
    }
}

$token = Security::get_token();
echo Display::page_header(get_lang('GradebookListOfStudentsCertificates'));

if (!empty($content)) {
    echo $content;
}

//@todo replace all this code with something like get_total_weight()
$cats = Category::load($categoryId, null, null, null, null, null, false);

if (!empty($cats)) {
    //with this fix the teacher only can view 1 gradebook
    if (api_is_platform_admin()) {
        $stud_id = (api_is_allowed_to_edit() ? null : api_get_user_id());
    } else {
        $stud_id = api_get_user_id();
    }

    $total_weight = $cats[0]->get_weight();
    $allcat = $cats[0]->get_subcategories(
        $stud_id,
        api_get_course_id(),
        api_get_session_id()
    );
    $alleval = $cats[0]->get_evaluations($stud_id);
    $alllink = $cats[0]->get_links($stud_id);

    $datagen = new GradebookDataGenerator($allcat, $alleval, $alllink);

    $total_resource_weight = 0;
    if (!empty($datagen)) {
        $data_array = $datagen->get_data(
            0,
            0,
            null,
            true
        );

        if (!empty($data_array)) {
            $newarray = [];
            foreach ($data_array as $data) {
                $newarray[] = array_slice($data, 1);
            }

            foreach ($newarray as $item) {
                $total_resource_weight = $total_resource_weight + $item['2'];
            }
        }
    }

    if ($total_resource_weight != $total_weight) {
        echo Display::return_message(
            get_lang('SumOfActivitiesWeightMustBeEqualToTotalWeight'),
            'warning'
        );
    }
}

$actions = '';
$actions .= Display::url(
    Display::return_icon('tuning.png', get_lang('GenerateCertificates'), [], ICON_SIZE_MEDIUM),
    $url.'&action=generate_all_certificates',
    ['id' => 'btn-generate-all-certificates']
);
$actions .= Display::url(
    Display::return_icon('delete.png', get_lang('DeleteAllCertificates'), [], ICON_SIZE_MEDIUM),
    $url.'&action=delete_all_certificates'
);

// Descarga masiva en HTML paginado (impresión desde el navegador, sin generar
// PDF en el servidor). Se muestra siempre que haya certificados.
if (count($certificate_list) > 0) {
    $actions .= Display::url(
        Display::return_icon('file_html.png', get_lang('Download').' '.get_lang('Certificates').' (HTML)', [], ICON_SIZE_MEDIUM),
        api_get_path(WEB_PLUGIN_PATH)
        .'easycertificate/src/view_certificates_all.php?'.api_get_cidreq().'&'
        .http_build_query([
            'course_code' => api_get_course_id(),
            'session_id' => api_get_session_id(),
            'cat_id' => $categoryId,
        ]),
        ['target' => '_blank']
    );
}

$hideCertificateExport = api_get_setting('hide_certificate_export_link');

if (count($certificate_list) > 0 && $hideCertificateExport !== 'true') {
    $paramsExport = [
        'export_all_in_one' => 1,
        'course_code' => api_get_course_id(),
        'session_id' => api_get_session_id(),
        'cat_id' => $categoryId,
    ];
    if ($allowCustomCertificate) {
        $actions .= Display::url(
            Display::return_icon('pdf.png', get_lang('ExportAllCertificatesToPDF'), [], ICON_SIZE_MEDIUM),
            api_get_path(WEB_PLUGIN_PATH)
                .'customcertificate/src/print_certificate.php?'.api_get_cidreq().'&'
                .http_build_query(
                $paramsExport
                )
        );
    } if($allowEasyCertificate) {
        $actions .= Display::url(
            Display::return_icon('pdf.png', get_lang('ExportAllCertificatesToPDF'), [], ICON_SIZE_MEDIUM),
            api_get_path(WEB_PLUGIN_PATH)
            .'easycertificate/src/print_certificate.php?'.api_get_cidreq().'&'
            .http_build_query(
                $paramsExport
            )
        );
    } else {
        $actions .= Display::url(
            Display::return_icon('pdf.png', get_lang('ExportAllCertificatesToPDF'), [], ICON_SIZE_MEDIUM),
            '#',
            ['id' => 'btn-export-all']
        );
    }

    $actions .= Display::url(
        Display::return_icon('export_csv.png', get_lang('ExportCertificateReport'), [], ICON_SIZE_MEDIUM),
        $url.'&action=download_certificates_report'
    );

    if ($allowCustomCertificate || $allowEasyCertificate) {
        $actions .= Display::url(
            Display::return_icon('file_zip.png', get_lang('ExportAllCertificatesToZIP'), [], ICON_SIZE_MEDIUM),
            $url.'&action=export_all_certificates_zip'
        );
    }

    $actions .= Display::url(
        Display::return_icon('notification_mail.png', get_lang('SendCertificateNotifications'), [], ICON_SIZE_MEDIUM),
        $url.'&action=show_notification_form'
    );
}

echo Display::toolbarAction('actions', [$actions]);
echo $filterForm;

// Selector de orden de la lista (nombre / fecha de emisión asc-desc)
if (count($certificate_list) > 0) {
    $sortBaseUrl = api_get_self().'?'.api_get_cidreq().'&cat_id='.$categoryId.'&filter='.$filterOfficialCodeGet.'&sort=';
    $sortOptions = [
        'name' => 'Apellidos y nombres (A-Z)',
        'date_asc' => 'Fecha de emisión (más antiguos primero)',
        'date_desc' => 'Fecha de emisión (más recientes primero)',
    ];
    echo '<div class="form-inline" style="margin-bottom: 15px;">
        <label for="sort-certificates">Ordenar por</label>
        <select id="sort-certificates" class="form-control" style="margin-left: 5px;">';
    foreach ($sortOptions as $optionValue => $optionLabel) {
        $selected = $optionValue === $sortCertificates ? ' selected' : '';
        echo '<option value="'.$optionValue.'"'.$selected.'>'.$optionLabel.'</option>';
    }
    echo '</select>
    </div>
    <script>
    $(function () {
        $("#sort-certificates").on("change", function () {
            window.location.href = '.json_encode($sortBaseUrl).' + this.value;
        });
    });
    </script>';
}

// Modal para generar certificados con fecha personalizada opcional
echo '
<div class="modal fade" id="generate-certificates-modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">'.get_lang('GenerateCertificates').'</h4>
            </div>
            <div class="modal-body">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="custom-date-check"> Fecha personalizada
                    </label>
                </div>
                <div class="form-group">
                    <label for="custom-date-value">Fecha y hora de emisi&oacute;n</label>
                    <input type="datetime-local" class="form-control" id="custom-date-value" disabled>
                    <p class="help-block">Si no marca "Fecha personalizada", los certificados se generar&aacute;n con la fecha y hora actual, como hasta ahora.</p>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="send-mail-check" checked> Enviar correo de notificaci&oacute;n a los estudiantes
                    </label>
                    <p class="help-block">Solo se env&iacute;a a los estudiantes cuyo certificado se genere en esta acci&oacute;n.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">'.get_lang('Cancel').'</button>
                <button type="button" class="btn btn-primary" id="confirm-generate-certificates">'.get_lang('GenerateCertificates').'</button>
            </div>
        </div>
    </div>
</div>
<script>
$(function () {
    var generateUrl = $("#btn-generate-all-certificates").attr("href");

    $("#btn-generate-all-certificates").on("click", function (e) {
        e.preventDefault();
        $("#generate-certificates-modal").modal("show");
    });

    $("#custom-date-check").on("change", function () {
        $("#custom-date-value").prop("disabled", !this.checked);
    });

    $("#confirm-generate-certificates").on("click", function () {
        var target = generateUrl;
        if ($("#custom-date-check").is(":checked")) {
            var value = $("#custom-date-value").val();
            if (!value) {
                alert("Debe seleccionar la fecha y hora de emisión.");
                return;
            }
            // datetime-local => "YYYY-MM-DDTHH:MM"
            target += "&custom_date=" + encodeURIComponent(value.replace("T", " ") + ":00");
        }
        if (!$("#send-mail-check").is(":checked")) {
            target += "&send_mail=0";
        }
        window.location.href = target;
    });
});
</script>';

if (count($certificate_list) == 0) {
    echo Display::return_message(get_lang('NoResultsAvailable'), 'warning');
} else {
    echo '<table class="table data_table">';
    echo '<tbody>';
    foreach ($certificate_list as $index => $value) {
        echo '<tr>
                <td width="100%" class="actions"><strong>'.get_lang('Student').' :</strong> '.api_get_person_name($value['firstname'], $value['lastname']).' ('.$value['username'].')</td>';
        echo '</tr>';
        echo '<tr><td>
            <table class="table data_table">
                <tbody>';

        $list = GradebookUtils::get_list_gradebook_certificates_by_user_id(
            $value['user_id'],
            $categoryId
        );
        foreach ($list as $valueCertificate) {
            echo '<tr>';
            echo '<td width="50%"><strong>'.get_lang('Score').' : </strong> '.$valueCertificate['score_certificate'].'</td>';
            echo '<td width="30%"><strong>'.get_lang('Date').' : </strong> '.api_convert_and_format_date($valueCertificate['created_at']).'</td>';
            echo '<td width="20%">';

                $url = api_get_path(WEB_PATH).'certificates/index.php?id='.$valueCertificate['id'].'&user_id='.$value['user_id'];
                $certificateUrl = Display::url(
                    get_lang('Certificate'),
                    $url,
                    ['target' => '_blank', 'class' => 'btn btn-default']
                );
                echo $certificateUrl.PHP_EOL;

            if ($hideCertificateExport !== 'true') {
                $url .= '&action=export';
                $pdf = Display::url(
                    Display::return_icon('pdf.png', get_lang('Download')),
                    $url,
                    ['target' => '_blank']
                );
                echo $pdf.PHP_EOL;
            }
            echo '<a onclick="return confirmation();" href="gradebook_display_certificate.php?sec_token='.$token.'&'.api_get_cidreq().'&action=delete&cat_id='.$categoryId.'&certificate_id='.$valueCertificate['id'].'">
                    '.Display::return_icon('delete.png', get_lang('Delete')).'
                  </a>'.PHP_EOL;
            echo '</td></tr>';
        }
        echo '</tbody>';
        echo '</table>';
        echo '</td></tr>';
    }
    echo '</tbody>';
    echo '</table>';

    echo GradebookUtils::returnJsExportAllCertificates(
        '#btn-export-all',
        $categoryId,
        api_get_course_id(),
        api_get_session_id(),
        $filterOfficialCodeGet
    );
}
Display::display_footer();
