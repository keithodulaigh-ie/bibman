<?php

require_once 'config.inc.php';

if (isset($_POST['action']) && $_POST['action'] == "register") {
    $newEmail = filter_input(INPUT_POST, "email_address");
    $displayName = filter_input(INPUT_POST, "display_name_input");
    $password = filter_input(INPUT_POST, "password");

    createUser($newEmail, $displayName, $password);

    header("Location: index.php");
}

$template->display('register.tpl');
?>