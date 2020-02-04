<?php include "../include/connection.php";?>

<?php

$sql = "select * from tb_field";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Name: " . $row["name"] . "<br>";
    }
} else {
    echo "0 results ";
}

$conn->close();
?>