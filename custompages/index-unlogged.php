<?php
/* For licensing terms, see /license.txt */
/**
 * Redirect script.
 *
 * @package chamilo.custompages
 */
require_once api_get_path(SYS_PATH).'main/inc/global.inc.php';
require_once __DIR__.'/language.php';

/**
 * Homemade micro-controller.
 */
if (isset($_GET['loginFailed'])) {
    if (isset($_GET['error'])) {
        switch ($_GET['error']) {
            case 'account_expired':
                $error_message = custompages_get_lang('AccountExpired');
                break;
            case 'account_inactive':
                $error_message = custompages_get_lang('AccountInactive');
                break;
            case 'user_password_incorrect':
                $error_message = custompages_get_lang('InvalidId');
                break;
            case 'access_url_inactive':
                $error_message = custompages_get_lang('AccountURLInactive');
                break;
            default:
                $error_message = custompages_get_lang('InvalidId');
        }
    } else {
        $error_message = get_lang('InvalidId');
    }
}

$rootWeb = api_get_path('WEB_PATH');

/**
 * HTML output.
 */
?>
<html>
<head>
	<title>AulaVirtual</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <!-- <link rel="stylesheet" type="text/css" href="<?php echo $rootWeb; ?>web/assets/bootstrap/dist/css/bootstrap.min.css" /> -->
    <link rel="stylesheet"
          href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"/>

    <link rel="stylesheet" type="text/css" href="<?php echo $rootWeb; ?>web/assets/flag-icon-css/css/flag-icon.min.css" />

    <link rel="stylesheet"
          href="<?= $rootWeb; ?>web/assets/fontawesome/css/font-awesome.min.css" />

    <link rel="stylesheet" href="<?= $rootWeb; ?>custompages/css/unlogged.css?v=2"/>

    <script type="text/javascript" src="<?php echo $rootWeb; ?>web/assets/jquery/dist/jquery.min.js"></script>
<!-- <script type="text/javascript" src="<?php echo $rootWeb; ?>web/assets/bootstrap/dist/js/bootstrap.min.js"></script> -->
<script defer src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	<script>
		$(document).ready(function() {
			if (top.location != location) {
                top.location.href = document.location.href;
            }

			// Handler pour la touche retour
			$('input').keyup(function(e) {
				if (e.keyCode == 13) {
					$('#login-form').submit();
				}
			});
		});
	</script>
        <style>
        @media (min-width: 992px) {
            
        }
        .wrapper {
            background: url('http://aulavirtual.cigamperu.com/custompages/images/portada.png') center/cover no-repeat;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="container">
            <div id="header" class="py-3">
                <img class="ddt-img img-fluid w-100" src="<?= $rootWeb; ?>/custompages/images/LOGO-CIGAM2.png"
                        alt="Logo" />
            </div>
        </div>
    </header>
	<div id="wrapper" class="wrapper fadeInDown">
        <div class="container h-100 d-flex align-items-center">
		<div id="login-form-box" class="form-box">
            <div id="login-form-info" class="form-info shadow-lg">
            <?php
                echo Display::getFlashToString();
                Display::cleanFlashMessages();
                if (isset($content['info']) && !empty($content['info'])) {
                    echo $content['info'];
                }
            ?>
            </div>
            <?php if (isset($error_message)) {
                echo '<div id="login-form-info" class="form-error">'.$error_message.'</div>';
            }
            ?>
            <h1 class="int-color text-center mb-4">Bienvenido al Aula Virtual</h1>

            <form id="login-form" class="form" action="<?php echo api_get_path(WEB_PATH); ?>index.php" method="post">
                <div class="group fadeIn second position-relative">
                    <input class="form-control mb-2" 
                            required
                            autocomplete
                            name="login" 
                            type="text" 
                            placeholder="<?php echo custompages_get_lang('User'); ?>" />
                    <i class="fa fa-user position-absolute"></i>
                </div>
                <div class="group fadeIn third position-relative">
                    <input class="form-control" 
                            required name="password" 
                            type="password" 
                            placeholder="<?php echo custompages_get_lang('Password'); ?>" />
                    <i class="fa fa-lock position-absolute"></i>
                </div>
            </form>
            <div id="login-form-submit" class="form-submit" onclick="document.forms['login-form'].submit();">
                <button class="btn btn-block int-color-btn text-white my-3"><span>Ingresar</span></button>
            </div> <!-- #form-submit -->
			<div id="links" class="fadeIn fifth text-center">

                <?php if (api_get_setting('allow_registration') === 'true') {
                ?>
                <a  class="underlineHover" href="<?php echo api_get_path(WEB_CODE_PATH); ?>auth/inscription.php?language=<?php echo api_get_interface_language(); ?>">
                    <?php echo custompages_get_lang('Registration'); ?>
                </a><br />
                <?php
            } ?>
                
                <a class="underlineHover" href="<?php echo api_get_path(WEB_CODE_PATH); ?>auth/lostPassword.php?language=<?php echo api_get_interface_language(); ?>">
                    <?php echo custompages_get_lang('LostPassword'); ?>
                </a>
			</div>
		</div> <!-- #form -->
    </div>
	</div> <!-- #wrapper -->
    <footer class="footer">
        <div class="container">
            <div class="py-3 text-white text-right font-weight-bold">Diseñado por <a class="underlineHover-ng" href="https://atecinnova.pe/" target="_blank"> Atecinnova</a></div>
        </div>
    </footer>  
</body>
</html>
