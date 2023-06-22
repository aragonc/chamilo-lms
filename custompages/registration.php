<?php
/* For licensing terms, see /license.txt */
/**
 * This script allows for specific registration rules (see CustomPages feature of Chamilo)
 * Please contact CBlue regarding any licences issues.
 * Author: noel@cblue.be
 * Copyright: CBlue SPRL, 20XX (GNU/GPLv3).
 *
 * @package chamilo.custompages
 */
require_once api_get_path(SYS_PATH).'main/inc/global.inc.php';
require_once __DIR__.'/language.php';

$template = new Template(get_lang('Registration'), false, false, false, false, true, true);

/**
 * Removes some unwanted elementend of the form object.
 * 03-26-2020  Added check if element exist.
 */
$template->assign('url_plugin', $content['url_plugin']);
$template->assign('title', $content['title']);
$template->assign('form', $content['form']->returnForm());
$layout = $template->get_template('custompage/registration.tpl');
$content = $template->fetch($layout);
$template->assign('content', $content);
$template->display_blank_template();
