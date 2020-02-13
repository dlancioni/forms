<?php
    $servername = "127.0.0.1:3306";
    $username = "david";
    $password = "david";
    $dbname = "admin";;

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8");
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
