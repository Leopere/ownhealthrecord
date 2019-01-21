<?php
// Connects to my Database
$db_host = "database";
$db_user = "root";
$db_pass = "root123";
$db_table = "ownhealthrecord";

$connection = mysqli_connect($db_host, $db_user, $db_pass);
mysqli_select_db($connection, $db_table);
?> 
