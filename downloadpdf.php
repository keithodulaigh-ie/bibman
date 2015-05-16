<?php

require_once 'config.inc.php';

header("Content: application/pdf");

echo getPdf($_SESSION['email_address'], $_GET['record'])[0];

?>