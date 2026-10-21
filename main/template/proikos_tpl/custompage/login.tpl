<script src="https://www.google.com/recaptcha/enterprise.js?render=6LdtBDcrAAAAAAhENW2wEv233wvPb6TOcrZ4p4ya"></script>
<!-- Your code -->
<link rel="stylesheet" href="{{ _p.web_css_theme }}vegas/vegas.min.css">
<div class="custompage">
        <div class="limiter">
        <div class="container-login">
            <div class="wrap-login width-login">
                <form class="login100-form validate-form" action="{{ _p.web }}" method="post">
                    <div class="row">

                        <div class="col-md-6">
                            <div id="vegas">
                                <div class="logo" style="text-align: center">
                                    <a href="{{ _p.web }}">
                                    <img width="200px" class="img-responsive pk-site-logo" style="display: inline-block;" title="{{ _s.site_name }}" data-default-src="{{ _p.web_css_theme }}images/logo.svg" src="{{ proikos_appearance.logo|default(_p.web_css_theme ~ 'images/logo.svg') }}">
                                    </a>
                                </div>
                                {% set pk_default_description = 'Nos alegra verte de nuevo, ingresa tus datos y accede a tu aula virtual' %}
                                <div class="description" data-pk-live="login_description" data-default="{{ pk_default_description }}">
                                    {% if proikos_appearance.login_description %}{{ proikos_appearance.login_description|e|nl2br }}{% else %}{{ pk_default_description }}{% endif %}
                                </div>
                                <div class="character">
                                    <img width="287px" class="img-responsive pk-login-character" style="display: inline-block;" data-default-src="{{ _p.web_css_theme }}images/character.png" src="{{ proikos_appearance.login_character|default(_p.web_css_theme ~ 'images/character.png') }}">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="padding-login">
                                <h3 class="title" data-pk-live="login_title" data-default="Bienvenidos a {{ _s.site_name|e }}">{% if proikos_appearance.login_title %}{{ proikos_appearance.login_title|e }}{% else %}Bienvenidos a {{ _s.site_name }}{% endif %}</h3>
                                {{ mgs_flash }}
                                {% if error %}
                                <div class="alert alert-warning" role="alert">
                                    {{ error }}
                                </div>
                                {% endif %}
                                <div class="pk-login-fields">
                                    <div class="form-group">
                                        <label for="user">Usuario (DNI)</label>
                                        <input type="text" class="form-control" id="user" name="login"
                                               placeholder="Ingresa tu número de DNI" autocomplete="username"
                                               autocapitalize="none" spellcheck="false" required autofocus>
                                    </div>
                                    <div class="form-group">
                                        <label for="password">{{ 'Password'|get_lang() }}</label>
                                        <div class="pk-login-pass">
                                            <input type="password" class="form-control" name="password" id="password"
                                                   placeholder="Ingresa tu contraseña" autocomplete="current-password" required>
                                            <button type="button" class="pk-login-pass-toggle" id="pk-login-pass-toggle"
                                                    aria-label="Mostrar contraseña" aria-pressed="false" tabindex="-1">
                                                <i class="fa fa-eye" aria-hidden="true"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="last-password">
                                    <a href="{{ url_lost_password }}">
                                        {{ 'LostPassword'|get_lang() }}
                                    </a>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block">
                                    Iniciar sesión
                                </button>
                                {% if url_register %}
                                <a href="{{ url_register }}" class="btn btn-success btn-block" >
                                    Registro de usuario
                                </a >
                                {% endif %}

                                {% set pk_default_message = 'Por razones de seguridad, no olvides cerrar la sesión, incluso antes de cerrar el navegador.' %}
                                <div class="message" data-pk-live="login_message" data-default="{{ pk_default_message }}">
                                    {% if proikos_appearance.login_message %}{{ proikos_appearance.login_message|e|nl2br }}{% else %}{{ pk_default_message }}{% endif %}
                                </div>
                                <div class="software-name">
                                    <a href="{{_p.web}}" target="_blank">
                                        {{ "PoweredByX" |get_lang | format(_s.software_name) }}
                                    </a>&copy; {{ "now"|date("Y") }}
                                </div>
                            </div>

                        </div>

                    </div>

                </form>

            </div>
        </div>
    </div>
</div>
<style>
    /* Campos del login con el mismo aspecto que el formulario de inscripción */
    .custompage .pk-login-fields {
        --pk-accent: var(--primary-color, #008AD1);
        --pk-border: #d5dde6;
        --pk-text: #1f2d3d;
    }
    .custompage .pk-login-fields .form-group {
        margin: 0 0 18px;
    }
    .custompage .pk-login-fields label {
        display: block;
        margin: 0 0 6px;
        font-size: 13px;
        font-weight: 600;
        color: var(--pk-text);
    }
    .custompage .pk-login-fields .form-control {
        width: 100%;
        height: 44px;
        padding: 10px 12px;
        font-size: 14px;
        color: var(--pk-text);
        background: #fff;
        border: 1px solid var(--pk-border);
        border-radius: 8px;
        box-shadow: none;
        transition: border-color .15s ease, box-shadow .15s ease;
    }
    .custompage .pk-login-fields .form-control::placeholder {
        color: #a3afbd;
    }
    .custompage .pk-login-fields .form-control:focus {
        border-color: var(--pk-accent);
        box-shadow: 0 0 0 3px rgba(0, 138, 209, .15);
        outline: 0;
    }
    .custompage .pk-login-pass {
        position: relative;
    }
    .custompage .pk-login-pass .form-control {
        padding-right: 44px;
    }
    /* Oculta el ojo nativo de Edge para no duplicar el botón */
    .custompage .pk-login-pass input::-ms-reveal,
    .custompage .pk-login-pass input::-ms-clear {
        display: none;
    }
    .custompage .pk-login-pass-toggle {
        z-index: 2;
        position: absolute;
        top: 0;
        right: 0;
        width: 44px;
        height: 44px;
        padding: 0;
        color: #8a97a6;
        background: none;
        border: 0;
        cursor: pointer;
    }
    .custompage .pk-login-pass-toggle:hover,
    .custompage .pk-login-pass-toggle[aria-pressed="true"] {
        color: var(--pk-accent);
    }
    .custompage .width-login .last-password {
        margin: -6px 0 22px;
    }
    .custompage .width-login .btn-block {
        height: 44px;
        padding-top: 0;
        padding-bottom: 0;
        line-height: 42px;
        border-radius: 8px;
    }
    .custompage .width-login .btn-block + .btn-block {
        margin-top: 10px;
    }
</style>
<script>
    (function () {
        var toggle = document.getElementById('pk-login-pass-toggle');
        var input = document.getElementById('password');
        if (!toggle || !input) {
            return;
        }
        // Evita que el botón le quite el foco al campo.
        toggle.addEventListener('mousedown', function (e) {
            e.preventDefault();
        });
        toggle.addEventListener('click', function () {
            var show = input.type === 'password';
            var value = input.value;
            input.type = show ? 'text' : 'password';
            // Con autocompletado del navegador el valor sigue enmascarado
            // tras cambiar el tipo; reasignarlo lo convierte en texto normal.
            input.value = value;
            toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
            toggle.setAttribute('aria-label', show ? 'Ocultar contraseña' : 'Mostrar contraseña');
            toggle.querySelector('i').className = show ? 'fa fa-eye-slash' : 'fa fa-eye';
            input.focus();
        });
    })();

    function onClick(e) {
        e.preventDefault();
        grecaptcha.enterprise.ready(async () => {
            const token = await grecaptcha.enterprise.execute('6LdtBDcrAAAAAAhENW2wEv233wvPb6TOcrZ4p4ya', {action: 'LOGIN'});
        });
    }
</script>

{% set libro_reclamaciones_enabled = 'proikos'|api_get_plugin_setting('enable_libro_reclamaciones') %}
{% set libro_reclamaciones_url = 'proikos'|api_get_plugin_setting('libro_reclamaciones_url') %}
{% if libro_reclamaciones_enabled == 'true' and libro_reclamaciones_url %}
<a href="{{ libro_reclamaciones_url }}" target="_blank" rel="noopener"
   id="libro-reclamaciones-btn" class="lr-login"
   title="Libro de Reclamaciones">
    <img src="{{ _p.web_plugin }}proikos/images/libro_reclamaciones.png" alt="Libro de Reclamaciones" class="lr-icon">
    <span class="lr-label">Libro de<br>Reclamaciones</span>
</a>
<style>
    #libro-reclamaciones-btn {
        position: fixed;
        right: 20px;
        bottom: 110px;
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
