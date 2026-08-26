<!DOCTYPE html>
<!--[if lt IE 7]> <html lang="{{ document_language }}" class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>    <html lang="{{ document_language }}" class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>    <html lang="{{ document_language }}" class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html lang="{{ document_language }}" class="no-js"> <!--<![endif]-->
<head>
{% block head %}
    {% include 'layout/head.tpl'|get_template %}
{% endblock %}
</head>
<body class="{{ 'page_origin' ? ('page_origin_' ~ page_origin) : '' }}">
    <!-- START MAIN -->
    <main id="main" dir="{{ text_direction }}" class="{{ section_name }} {{ login_class }}">
    <noscript>{{ "NoJavascript"|get_lang }}</noscript>

            {% if displayCookieUsageWarning == true %}
                <!-- START DISPLAY COOKIES VALIDATION -->
                <div class="toolbar-cookie alert-warning">
                    <form onSubmit="$(this).toggle('slow')" action="" method="post">
                        <input value=1 type="hidden" name="acceptCookies"/>
                        <div class="cookieUsageValidation">
                            {{ 'YouAcceptCookies' | get_lang }}
                            <span style="margin-left:20px;" onclick="$(this).next().toggle('slow'); $(this).toggle('slow')">
                                ({{"More" | get_lang }})
                            </span>
                            <div style="display:none; margin:20px 0;">
                                {{ "HelpCookieUsageValidation" | get_lang}}
                            </div>
                            <span style="margin-left:20px;" onclick="$(this).parent().parent().submit()">
                                ({{"Accept" | get_lang }})
                            </span>
                        </div>
                    </form>
                </div>
                <!-- END DISPLAY COOKIES VALIDATION -->
            {% endif %}

            {% if show_header == true %}
                <!-- START HEADER -->
                <header id="cm-header">
                    {% include 'layout/page_header.tpl'|get_template %}
                </header>

            {% endif %}

            <!-- START CONTENT -->
            <section id="cm-content">
                <div class="container">
                    {% if show_course_shortcut is not null %}
                        <!-- TOOLS SHOW COURSE -->
                        <div id="cm-tools" class="nav-tools">
                            {{ show_course_shortcut }}
                        </div>
                        <!-- END TOOLS SHOW COURSE -->
                    {% endif %}

                    {% block breadcrumb %}
                        {{ breadcrumb }}
                    {% endblock %}

                    {% block body %}
                        {{ content }}
                    {% endblock %}
                </div>
            </section>
            <!-- END CONTENT -->

            {% if show_footer == true %}
            <!-- START FOOTER -->
            <footer class="footer">
                {% include 'layout/page_footer.tpl'|get_template %}
            </footer>
            <!-- END FOOTER -->
            {% endif %}

        </main>
    <!-- END MAIN -->

    {% include 'layout/modals.tpl'|get_template %}

    {% set libro_reclamaciones_enabled = 'proikos'|api_get_plugin_setting('enable_libro_reclamaciones') %}
    {% set libro_reclamaciones_url = 'proikos'|api_get_plugin_setting('libro_reclamaciones_url') %}
    {% if libro_reclamaciones_enabled == 'true' and libro_reclamaciones_url %}
    <a href="{{ libro_reclamaciones_url }}" target="_blank" rel="noopener"
       id="libro-reclamaciones-btn"
       class="{{ _u.logged ? 'lr-logged' : 'lr-login' }}"
       title="Libro de Reclamaciones">
        <img src="{{ _p.web_plugin }}proikos/images/libro_reclamaciones.png" alt="Libro de Reclamaciones" class="lr-icon">
        <span class="lr-label">Libro de<br>Reclamaciones</span>
    </a>
    <style>
        #libro-reclamaciones-btn {
            position: fixed;
            z-index: 100000;
            display: flex;
            align-items: center;
            gap: 8px;
            background: #1565c0;
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            padding: 10px 16px 10px 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,.35);
            font-size: 11px;
            font-weight: 700;
            line-height: 1.2;
            transition: transform .2s ease, box-shadow .2s ease;
        }
        #libro-reclamaciones-btn:hover,
        #libro-reclamaciones-btn:focus {
            color: #fff;
            transform: scale(1.06);
            box-shadow: 0 5px 16px rgba(0,0,0,.45);
            text-decoration: none;
        }
        #libro-reclamaciones-btn.lr-login {
            right: 20px;
            bottom: 110px;
        }
        #libro-reclamaciones-btn.lr-logged {
            right: 20px;
            bottom: 80px;
        }
        #libro-reclamaciones-btn .lr-icon {
            width: 36px;
            height: auto;
        }
        #libro-reclamaciones-btn .lr-label {
            text-transform: uppercase;
            letter-spacing: .3px;
        }
        @media (max-width: 767px) {
            #libro-reclamaciones-btn .lr-label {
                display: none;
            }
            #libro-reclamaciones-btn {
                padding: 12px;
                border-radius: 50%;
            }
        }
    </style>
    {% endif %}
</body>
</html>