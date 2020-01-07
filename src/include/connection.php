<?php
$servername = "localhost";
$username = "app";
$password = "app";

// Create connection
echo $servername;
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";
?>