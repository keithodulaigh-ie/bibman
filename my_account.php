<?php

require_once 'config.inc.php';

if(isset($_POST['action']) && $_POST['action'] == "update") {
    $newEmail = filter_input(INPUT_POST, "email_address");
    $displayName = filter_input(INPUT_POST, "display_name_input");
    $password = filter_input(INPUT_POST, "password");
    
    updateUser($_SESSION['email_address'], $newEmail, $displayName, $password); 
    
    header("Location: bibliography.php");
}

$template->display('my_account.tpl');
?>