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
                                    <img width="200px" class="img-responsive" style="display: inline-block;" title="{{ _s.site_name }}" src="{{ _p.web_css_theme }}images/logo.svg">
                                    </a>
                                </div>
                                <div class="description">
                                    Nos alegra verte de nuevo, ingresa tus datos y accede a tu aula virtual
                                </div>
                                <div class="character">
                                    <img width="287px" class="img-responsive" style="display: inline-block;" src="{{ _p.web_css_theme }}images/character.png">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="padding-login">
                                <h3 class="title">Bienvenidos a {{ _s.site_name }}</h3>
                                {{ mgs_flash }}
                                {% if error %}
                                <div class="alert alert-warning" role="alert">
                                    {{ error }}
                                </div>
                                {% endif %}
                                <div class="form-group">
                                    <label for="user">Usuario (DNI)</label>
                                    <input type="text" class="form-control" id="user" name="login" ">
                                </div>
                                <div class="form-group">
                                    <label for="password">{{ 'Password'|get_lang() }}</label>
                                    <input type="password" class="form-control" name="password" id="password" >
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

                                <div class="message">
                                    Por razones de seguridad, no olvides cerrar la sesión, incluso antes de cerrar el navegador.
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
<script>
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
