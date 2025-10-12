<?php

/* For licensing terms, see /license.txt */

require_once __DIR__.'/../inc/global.inc.php';
require_once api_get_path(SYS_CODE_PATH).'gradebook/lib/fe/exportgradebook.php';

$current_course_tool = TOOL_GRADEBOOK;

api_protect_course_script(true);

api_block_anonymous_users();
$isDrhOfCourse = CourseManager::isUserSubscribedInCourseAsDrh(
    api_get_user_id(),
    api_get_course_info()
);

if (!$isDrhOfCourse) {
    GradebookUtils::block_students();
}

$categoryId = isset($_REQUEST['selectcat']) ? (int) $_REQUEST['selectcat'] : 0;

if (isset($_POST['submit']) && isset($_POST['keyword'])) {
    header('Location: '.api_get_self().'?selectcat='.$categoryId.'&search='.Security::remove_XSS($_POST['keyword']));
    exit;
}

$interbreadcrumb[] = [
    'url' => Category::getUrl().'selectcat=1',
    'name' => get_lang('ToolGradebook'),
];

$showeval = isset($_POST['showeval']) ? '1' : '0';
$showlink = isset($_POST['showlink']) ? '1' : '0';
if ($showlink == '0' && $showeval == '0') {
    $showlink = '1';
    $showeval = '1';
}

$cat = Category::load($categoryId);
$userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 0;

$alleval = null;
if ($showeval) {
    $alleval = $cat[0]->get_evaluations($userId, true);
}

$alllinks = null;
if ($showlink) {
    $alllinks = $cat[0]->get_links($userId, true);
}

if (isset($export_flatview_form) && 'pdf' === !$file_type) {
    Display::addFlash(
        Display::return_message(
            $export_flatview_form->toHtml(),
            'normal',
            false
        )
    );
}
$category_id = 0;
if (isset($_GET['selectcat'])) {
    $category_id = (int) $_GET['selectcat'];
}

$simple_search_form = new UserForm(
    UserForm::TYPE_SIMPLE_SEARCH,
    null,
    'simple_search_form',
    null,
    api_get_self().'?selectcat='.$category_id.'&'.api_get_cidreq()
);
$values = $simple_search_form->exportValues();

$keyword = '';
if (isset($_GET['search']) && !empty($_GET['search'])) {
    $keyword = Security::remove_XSS($_GET['search']);
}
if ($simple_search_form->validate() && empty($keyword)) {
    $keyword = $values['keyword'];
}

if (!empty($keyword)) {
    $users = GradebookUtils::find_students($keyword);
} else {
    $users = null;
    if (isset($alleval) && isset($alllinks)) {
        $users = GradebookUtils::get_all_users($alleval, $alllinks);
    }
}
$offset = isset($_GET['offset']) ? $_GET['offset'] : '0';

$addparams = ['selectcat' => $cat[0]->get_id()];
if (isset($_GET['search'])) {
    $addparams['search'] = $keyword;
}

// Main course category
$mainCourseCategory = Category::load(
    null,
    null,
    api_get_course_id(),
    null,
    null,
    api_get_session_id()
);

$flatViewTable = new FlatViewTable(
    $cat[0],
    $users,
    $alleval,
    $alllinks,
    true,
    $offset,
    $addparams,
    $mainCourseCategory[0]
);

$flatViewTable->setAutoFill(false);
$parameters = ['selectcat' => $categoryId];
$flatViewTable->set_additional_parameters($parameters);

$params = [];
if (isset($_GET['export_pdf']) && 'category' === $_GET['export_pdf']) {
    $params['only_total_category'] = true;
    $params['join_firstname_lastname'] = true;
    $params['show_official_code'] = true;
    $params['export_pdf'] = true;
    if ($cat[0]->is_locked() == true || api_is_platform_admin()) {
        Display::set_header(null, false, false);
        GradebookUtils::export_pdf_flatview(
            $flatViewTable,
            $cat,
            $users,
            $alleval,
            $alllinks,
            $params,
            $mainCourseCategory[0]
        );
    }
}

if (isset($_GET['exportpdf'])) {
    $interbreadcrumb[] = [
        'url' => api_get_self().'?selectcat='.$categoryId.'&'.api_get_cidreq(),
        'name' => get_lang('FlatView'),
    ];

    $pageNum = isset($_GET['flatviewlist_page_nr']) ? intval($_GET['flatviewlist_page_nr']) : null;
    $perPage = isset($_GET['flatviewlist_per_page']) ? intval($_GET['flatviewlist_per_page']) : null;
    $url = api_get_self().'?'.api_get_cidreq().'&'.http_build_query([
        'exportpdf' => '',
        'offset' => $offset,
        'selectcat' => $categoryId,
        'flatviewlist_page_nr' => $pageNum,
        'flatviewlist_per_page' => $perPage,
    ]);

    $export_pdf_form = new DataForm(
        DataForm::TYPE_EXPORT_PDF,
        'export_pdf_form',
        null,
        $url,
        '_blank',
        ''
    );

    if ($export_pdf_form->validate()) {
        $params = $export_pdf_form->exportValues();
        Display::set_header();
        $params['join_firstname_lastname'] = true;
        $params['show_official_code'] = true;
        $params['export_pdf'] = true;
        $params['only_total_category'] = false;
        GradebookUtils::export_pdf_flatview(
            $flatViewTable,
            $cat,
            $users,
            $alleval,
            $alllinks,
            $params,
            $mainCourseCategory[0]
        );
    } else {
        Display::display_header(get_lang('ExportPDF'));
    }
}

if (isset($_GET['print'])) {
    $printable_data = GradebookUtils::get_printable_data(
        $cat[0],
        $users,
        $alleval,
        $alllinks,
        $params,
        $mainCourseCategory[0]
    );
    echo print_table(
        $printable_data[1],
        $printable_data[0],
        get_lang('FlatView'),
        $cat[0]->get_name()
    );
    exit;
}

if (!empty($_GET['export_report']) &&
    'export_report' === $_GET['export_report']
) {
    if (api_is_platform_admin() || api_is_course_admin() || api_is_session_general_coach() || $isDrhOfCourse) {
        $user_id = null;
        if (empty($_SESSION['export_user_fields'])) {
            $_SESSION['export_user_fields'] = false;
        }
        if (!api_is_allowed_to_edit() && !api_is_course_tutor()) {
            $user_id = api_get_user_id();
        }

        $params['show_official_code'] = true;
        $onlyScore = isset($_GET['only_score']) && 1 === (int) $_GET['only_score'];

        $printableData = GradebookUtils::get_printable_data(
            $cat[0],
            $users,
            $alleval,
            $alllinks,
            $params,
            $mainCourseCategory[0],
            $onlyScore
        );

        switch ($_GET['export_format']) {
            case 'xls':
                ob_start();
                $export = new GradeBookResult();
                $export->exportCompleteReportXLS($printableData);
                $content = ob_get_contents();
                ob_end_clean();
                echo $content;
                break;
            case 'doc':
                ob_start();
                $export = new GradeBookResult();
                $export->exportCompleteReportDOC($printableData);
                $content = ob_get_contents();
                ob_end_clean();
                echo $content;
                break;
            case 'csv':
            default:
                ob_start();
                $export = new GradeBookResult();
                $export->exportCompleteReportCSV($printableData);
                $content = ob_get_contents();
                ob_end_clean();
                echo $content;
                exit;
                break;
        }
    } else {
        api_not_allowed(true);
    }
}

$this_section = SECTION_COURSES;
if (isset($_GET['selectcat']) && ($_SESSION['studentview'] === 'teacherview')) {
    $htmlHeadXtra[] = '<script>
        $(function() {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-confirm").dialog({
                autoOpen: false,
                show: "blind",
                resizable: false,
                height:300,
                modal: true
            });

            $(".export_opener").click(function() {
                var targetUrl = $(this).attr("href");
                $("#dialog-confirm").dialog({
                    width:400,
                    height:300,
                    buttons: {
                        "'.addslashes(get_lang('Download')).'": function() {
                            let onlyScore = $("input[name=only_score]").prop("checked") ? 1 : 0;
                            location.href = targetUrl+"&only_score="+onlyScore;
                            $(this).dialog("close");
                        }
                   }
                });
                $("#dialog-confirm").dialog("open");
                return false;
            });
        });
        </script>';
}

if (isset($_GET['exportpdf'])) {
    $export_pdf_form->display();
} else {
    Display::display_header(get_lang('FlatView'));
}
if (isset($_GET['isStudentView']) && 'false' === $_GET['isStudentView']) {
    DisplayGradebook::display_header_reduce_flatview(
        $cat[0],
        $showeval,
        $showlink,
        $simple_search_form
    );
    $flatViewTable->display();
} elseif (isset($_GET['selectcat']) && ($_SESSION['studentview'] === 'teacherview')) {
    DisplayGradebook::display_header_reduce_flatview(
        $cat[0],
        $showeval,
        $showlink,
        $simple_search_form
    );
    $urlAjaxPlugin = api_get_path(WEB_PLUGIN_PATH)."proikos/src/ajax.php";
    // Table
    $flatViewTable->display();
    //@todo load images with jquery
    echo '<div id="contentArea" style="text-align: center;" >';
    $flatViewTable->display_graph_by_resource();

    echo '</div>';
    echo '
        <style>
            .btn-modal {
                margin: 2px;
            }

            .modal-header.bg-primary {
                background-color: #007bff !important;
            }

            .modal-header.bg-primary .text-white {
                color: white !important;
            }

            #sustenance_select {
                border: 1px solid #ced4da;
                border-radius: 0.25rem;
            }

            #sustenance_select option {
                padding: 5px;
            }

            .alert-info {
                border-left: 4px solid #17a2b8;
            }

            .form-text.text-muted {
                display: block;
                margin-top: 5px;
                font-size: 0.875rem;
            }
        </style>
    ';
    echo "<script>
            $(document).ready(function() {
                $(document).on('click', '.btn-modal', function() {
                    const userId = $(this).data('user-id');
                    const courseId = $(this).data('course-id');
                    const sessionId = $(this).data('session-id');
                    const userName = $(this).data('user-name');

                    // Llenar los campos ocultos
                    $('#sustenance_user_id').val(userId);
                    $('#sustenance_course_id').val(courseId);
                    $('#sustenance_session_id').val(sessionId);

                    // Mostrar información del usuario
                    $('#userIdDisplay').text(userId);
                    $('#userNameDisplay').text(userName);

                    // Limpiar los campos del formulario
                    document.getElementById('formIncidencia').reset();
                    $('#sustenance_select').val(null);

                    // Cargar datos existentes
                    loadExistingData(userId, courseId, sessionId);

                    // Mostrar modal
                    $('#modalIncidencia').modal('show');
                });


                    /**
                 * Guardar incidencia al hacer click en el botón
                 */
                $('#saveSustenanceBtn').click(function() {
                    const userId = $('#sustenance_user_id').val();
                    const sustainanceCodes = $('#sustenance_select').val();

                    // Validar que se haya seleccionado algo
                    if (!sustainanceCodes || sustainanceCodes.length === 0) {
                        alert('Debes seleccionar al menos un tipo de incidencia');
                        return;
                    }

                    const formData = {
                        user_id: userId,
                        course_id: $('#sustenance_course_id').val(),
                        session_id: $('#sustenance_session_id').val(),
                        record_id: $('#sustenance_record_id').val(),
                        sustenance_codes: sustainanceCodes,
                        comment: $('#sustenance_comment').val()
                    };

                    $.ajax({
                        url: '?action=save_sustenance',
                        method: 'POST',
                        dataType: 'json',
                        data: formData,
                        success: function(response) {
                            if (response.success) {
                                alert('Incidencia registrada exitosamente');
                                $('#modalIncidencia').modal('hide');
                                // Opcional: recargar la página o actualizar tabla
                                // location.reload();
                            } else {
                                alert('Error 1: ' + response.message);
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            alert('Error 2 al guardar los datos: ' + error);
                        }
                    });
                });
            });

            /**
             * Cargar datos existentes del servidor
             */
            function loadExistingData(userId, courseId, sessionId) {
                let urlAjax = '$urlAjaxPlugin'
                $.ajax({
                    url: urlAjax + '?action=get_sustenance',
                    method: 'POST',
                    dataType: 'json',
                    data: {
                        user_id: userId,
                        course_id: courseId,
                        session_id: sessionId
                    },
                    success: function(response) {
                        if (response.success && response.data) {
                            const data = response.data;

                            // Llenar el select con valores existentes
                            if (data.sustenance_codes) {
                                const codes = data.sustenance_codes.split(',').map(c => c.trim());
                                $('#sustenance_select').val(codes);
                            }

                            // Llenar otros campos
                            if (data.comment) {
                                $('#sustenance_comment').val(data.comment);
                            }
                            if (data.grade) {
                                $('#sustenance_grade').val(data.grade);
                            }
                            if (data.id) {
                                $('#sustenance_record_id').val(data.id);
                            }
                        }
                    },
                    error: function() {
                        console.log('No hay datos previos o error al cargar');
                    }
                });
            }



          </script>";
}

Display::display_footer();
