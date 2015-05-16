<?php

require_once 'config.inc.php';

$emailAddress = filter_input(INPUT_POST, "email", FILTER_SANITIZE_EMAIL);
$password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);

if (strlen($emailAddress) > 0 && strlen($password) > 0 && validLogin($emailAddress, $password)) {
    $_SESSION['email_address'] = $emailAddress;

    header("Location: bibliography.php");
} else {
    $template->assign('page_title', 'Welcome - Login');
    $template->display('index.tpl');
}
?>