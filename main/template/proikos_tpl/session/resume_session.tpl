
{% extends 'layout/layout_1_col.tpl'|get_template %}



{% block content %}
<style>

    .checkbtn {
        background: none;
        cursor: pointer;
        padding: 6px;
        transition: transform 0.3s ease;
    }

    .checkbtn:hover {
        transform: scale(1.1);
    }

    .check-image {
        width: 22px;
        height: 22px;
        transition: all 0.3s ease;
    }

    .checkbtn.loading .check-image {
        opacity: 0.5;
    }
</style>
{{ session_header }}
{{ title | remove_xss }}

<table id="session-properties" class="table table-hover table-striped data_table">
    <tr>
        <td>{{ 'CreatedBy'|get_lang }}</td>
        <td>{{ session_admin.complete_name_with_message_link }}</td>
    </tr>
    <tr>
        <td>{{ 'GeneralCoach' | get_lang}} :</td>
        <td>{{ general_coach.complete_name_with_message_link }}</td>
    </tr>
    {% if session_category %}
    <tr>
        <td>{{ 'SessionCategory' | get_lang}} </td>
        <td>{{ session_category }}</td>
    </tr>
    {% endif %}
    {% if session.duration > 0 %}
        <tr>
            <td>{{ 'Duration' | get_lang}} </td>
            <td>
                {{ session.duration }} {{ 'Days' | get_lang }}
            </td>
        </tr>
    {% else %}
        <tr>
            <td>{{ 'DisplayDates' | get_lang}} </td>
            <td>{{ session_dates.display }}</td>
        </tr>
        <tr>
            <td>{{ 'AccessDates' | get_lang}} </td>
            <td>{{ session_dates.access }}</td>
        </tr>
        <tr>
            <td>{{ 'CoachDates' | get_lang}} </td>
            <td>{{ session_dates.coach }}</td>
        </tr>
    {% endif %}
    <tr>
        <td>{{ 'Description' | get_lang}} </td>
        <td>
            {{ session.description | remove_xss }}
        </td>
    </tr>
    <tr>
        <td>{{ 'ShowDescription' | get_lang}} </td>
        <td>
            {% if session.show_description == 1 %}
                {{ 'Yes' | get_lang}}
            {% else %}
                {{ 'No' | get_lang}}
            {% endif %}
        </td>
    </tr>
    <tr>
        <td>{{ 'SessionVisibility' | get_lang}} </td>
        <td>
            {{ session_visibility }}
        </td>
    </tr>
    <tr>
        <td>{{ 'MaximumUsers' | get_lang}} </td>
        <td>
            {% if session.maximum_users > 0 %}
                {{ session.maximum_users }}
            {% else %}
             -
            {% endif %}
        </td>
    </tr>
    <tr>
        <td>{{ 'CodeReference' | get_lang}} </td>
        <td>
            {{ session.code_reference }}
        </td>
    </tr>
    <tr>
        <td>{{ 'Stakeholders' | get_lang}} </td>
        <td>
            {{ session.stakeholders }}
        </td>
    </tr>
    {% if promotion %}
        <tr>
            <td>{{ 'Career' | get_lang}}</td>
            <td>
                <a href="{{ _p.web_main }}admin/career_dashboard.php?filter={{ promotion.career.id }}&submit=&_qf__filter_form=">
                    {{ promotion.career.name }}
                </a>
            </td>
        </tr>
        <tr>
            <td>{{ 'Promotion' | get_lang}}</td>
            <td>
                <a href="{{ _p.web_main }}admin/promotions.php?action=edit&id={{ promotion.id }}">
                    {{ promotion.name }}
                </a>
            </td>
        </tr>
    {% endif %}
    {% if url_list %}
        <tr>
            <td>URL</td>
            <td>
            {% for url in url_list %}
                {{ url.url }}
            {% endfor %}
            </td>
        </tr>
    {% endif %}

    {% for extra_field in extra_fields %}
        <tr>
            <td>{{ extra_field.text }}</td>
            <td>{{ extra_field.value }}</td>
        </tr>
    {% endfor %}

    {% if programmed_announcement %}
        <tr>
            <td>{{ 'ScheduledAnnouncements' | get_lang}}</td>
            <td>
                <a class="btn btn-default" href="{{ _p.web_main }}session/scheduled_announcement.php?session_id={{ session.id }}">
                    {{ 'Edit' | get_lang }}
                </a>
            </td>
        </tr>
    {% endif %}
    
    {% if true == 'agenda_reminders'|api_get_configuration_value %}
        <tr>
            <td colspan="2">
                <a href="{{ _p.web_main }}session/import_course_agenda_reminders.php?session_id={{ session.id }}">
                    {{ 'ImportCourseEvents'|get_lang }}
                </a>
            </td>
        </tr>
    {% endif %}
</table>

{{ course_list }}
{{ user_list }}

{{ requirements }}
{{ dependencies }}

<script>
    $(function () {
        function loadFiles(courseId, sessionId) {
            return $.get('{{ _p.web_ajax }}session.ajax.php', {
                course: courseId,
                session: sessionId,
                a: 'get_basic_course_documents_list'
            });
        }

        function loadForm(courseId, sessionId) {
            return $.get('{{ _p.web_ajax }}session.ajax.php', {
                course: courseId,
                session: sessionId,
                a: 'get_basic_course_documents_form'
            });
        }

        var c = 0;

        $('.session-upload-file-btn').on('click', function (e) {
            e.preventDefault();

            var $self = $(this),
                $trParent = $self.parents('tr'),
                $trContainer = $trParent.next(),
                courseId = $self.data('course') || 0,
                sessionId = $self.data('session') || 0;

            $('.session-upload-file-tr').remove();

            if (courseId == c) {
                c = 0;

                return;
            }

            c = courseId;

            $trContainer = $('<tr>')
                .addClass('session-upload-file-tr')
                .html('<td colspan="4">{{ 'Loading'|get_lang }}</td>')
                .insertAfter($trParent);

            $.when
                .apply($, [loadFiles(courseId, sessionId), loadForm(courseId, sessionId)])
                .then(function (response1, response2) {
                    var filesCount = 0,
                        filesUploadedCount = 0;

                    $trContainer.find('td:first')
                        .html('<div id="session-' + sessionId + '-docs">' + response1[0] + '</div>'
                            + '<div id="session-' + sessionId + '-form">' + response2[0] + '</div>');

                    $('#input_file_upload')
                        .on('fileuploadadd', function (e, data) {
                            filesCount += data.files.length;
                        })
                        .on('fileuploaddone', function (e, data) {
                            filesUploadedCount += data.files.length;

                            data.context.parent().remove();

                            if (filesUploadedCount < filesCount) {
                                return;
                            }

                            $('#session-' + sessionId + '-docs').html('{{ 'Loading'|get_lang }}');

                            loadFiles(courseId, sessionId)
                                .then(function (response) {
                                    filesCount = 0;
                                    filesUploadedCount = 0;

                                    $('#session-' + sessionId + '-docs').html(response);
                                });
                        });
                });
        });

        $('#session-list-course').on('click', '.delete_document', function (e) {
            e.preventDefault();

            if (!confirm('{{ 'ConfirmYourChoice'|get_lang }}')) {
                return;
            }

            var $self = $(this),
                courseId = $self.data('course') || 0,
                sessionId = $self.data('session') || 0;

            $('#session-' + sessionId + '-docs').html('{{ 'Loading'|get_lang }}');

            $.ajax(this.href)
                .then(function () {
                    loadFiles(courseId, sessionId)
                        .then(function (response) {
                            $('#session-' + sessionId + '-docs').html(response);
                        })
                });
        });
    });
</script>

<!-- script check -->


<script>
    $(document).ready(function() {
        var urlAjax = '{{ url_ajax }}'
        // Verificar estado inicial de todos los botones
        verificarEstadosIniciales();

        // Event delegation para múltiples botones
        $(document).on('click', '.checkbtn', function(e) {
            e.preventDefault();

            var $btn = $(this);
            var $img = $btn.find('.check-image');
            var userId = $btn.data('user-id');
            var sessionId = $btn.data('session-id');
            console.log(userId);
            console.log(sessionId);
            // Determinar si está activo basándose en la imagen actual
            var isActive = $img.attr('src') === '{{ check_img }}';
            var newValue = isActive ? 0 : 1;
            console.log(isActive);
            // Agregar clase de carga
            $btn.addClass('loading');

            // Realizar la petición AJAX
            $.ajax({
                url: urlAjax + '?action=update_check',
                type: 'POST',
                dataType: 'json',
                data: {
                    user_id: userId,
                    session_id: sessionId,
                    check_document: newValue
                },
                success: function(response) {
                    if (response.success) {
                        // Cambiar la imagen
                        if (newValue === 1) {
                            $img.attr('src', '{{ check_img }}');
                        } else {
                            $img.attr('src', '{{ check_na_img }}');
                        }
                        console.log('Check actualizado para usuario: ' + userId);
                    } else {
                        alert('Error: ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('Error en la petición: ' + error);
                    console.log('Error AJAX:', error);
                },
                complete: function() {
                    // Remover clase de carga
                    $btn.removeClass('loading');
                }
            });
        });

        // Función para verificar el estado inicial de todos los botones
        function verificarEstadosIniciales() {
            var urlAjax = '{{ url_ajax }}'
            $('.checkbtn').each(function() {
                var $btn = $(this);
                var $img = $btn.find('.check-image');
                var userId = $btn.data('user-id');
                var sessionId = $btn.data('session-id');

                $.ajax({
                    url: urlAjax + '?action=verify_check',
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        user_id: userId,
                        session_id: sessionId
                    },
                    success: function(response) {
                        if (response.success) {
                            if (response.check_document === 1) {
                                $img.attr('src', '{{ check_img }}');
                            } else {
                                $img.attr('src', '{{ check_na_img }}');
                            }
                        }
                    },
                    error: function(xhr, status, error) {
                        console.log('Error al obtener estado:', error);
                    }
                });
            });
        }
    });
</script>


{% endblock %}
