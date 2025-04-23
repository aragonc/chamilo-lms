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

                                <h3 class="title">Bienvenidos a Proikos Academy</h3>
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

