<?php
/*
    unaux_25020096 
    $servername = "sql208.unaux.com";
    $username = "unaux_25020096";
    $password = "bt7vzg1esoo";
    $dbname = "unaux_25020096_forms";
*/

    $servername = "remotemysql.com";
    $username = "XzOenoVvhs";
    $password = "lYx8HYRaEb";
    $dbname = "XzOenoVvhs";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8");
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
