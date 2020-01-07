<?php
$servername = "sql208.unaux.com";
$username = "unaux_25020096";
$password = "bt7vzg1esoo";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

?>
