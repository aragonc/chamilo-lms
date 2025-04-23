<div class="custompage">
    <div class="limiter">
        <div class="container-login">
            <div class="wrap-login width-lost-password">
                <div class="row">
                    <div class="col-md-5">
                        <div id="vegas">
                            <div class="logo" style="text-align: center;">
                                <a href="{{ _p.web }}">
                                <img width="200px" class="img-responsive" style="display: inline-block;"
                                     title="{{ _s.site_name }}" src="{{ _p.web_css_theme }}images/logo.svg">
                                </a>
                            </div>
                            <div class="character">
                                <img width="350px" class="img-responsive" style="display: inline-block;"
                                     src="{{ _p.web_css_theme }}images/lost-password.png">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <div class="padding-login">
                            <h2 class="title-lost-password">¿Olvidaste tu contraseña?</h2>
                            {% if error %}
                            <div class="alert alert-warning" role="alert">
                                {{ error }}
                            </div>
                            {% endif %}

                            <form class="form-grid" action="/main/auth/lostPassword.php" method="post" name="lost_password" id="lost_password">
                                <div class="form-group">
                                    <label for="examlost_password_user" class="label-text-login">
                                        <span class="form_required">*</span>
                                        Usuario (DNI) o correo electrónico
                                    </label>
                                    <input class=" form-control" name="user" type="text" id="lost_password_user">
                                    <p class="help-block">Escriba el nombre de usuario o la dirección de correo electrónico con la que está registrado y le remitiremos su contraseña.</p>
                                </div>
                                <div class="form-group">
                                    <button class=" btn btn-primary btn-block" name="submit" type="submit" id="lost_password_submit">
                                        <em class="fa fa-paper-plane"></em> Enviar contraseña
                                    </button>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-2 col-sm-10"><span class="form_required">*</span> <small>Contenido obligatorio</small></div>
                                </div>
                                <input name="_qf__lost_password" type="hidden" value="" id="lost_password__qf__lost_password">
                            </form>
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
