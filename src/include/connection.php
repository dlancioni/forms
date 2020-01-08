<?php
    $servername = "sql208.unaux.com";
    $username = "unaux_25020096";
    $password = "bt7vzg1esoo";
    $dbname = "unaux_25020096_forms";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
