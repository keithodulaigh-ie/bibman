<?php

session_start();

$hostname = gethostname();

require_once 'include/Smarty.class.php';
require_once 'queries.php';
require_once "$hostname.config.inc.php";

define("WEBSITE_NAME", "BibMan");

$template = new Smarty;
$template->assign("website_name", WEBSITE_NAME);
?>