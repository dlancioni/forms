<?php
$servername = "sql208.unaux.com";
$username = "unaux_25020096";
$password = "bt7vzg1esoo";
$dbname = "unaux_25020096_forms";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT id, name FROM tb_form";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Name: " . $row["name"] . "<br>";
    }
} else {
    echo "0 results ";
}

echo "Descrição";

$conn->close();
?>