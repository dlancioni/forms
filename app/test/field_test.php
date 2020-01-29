<?php include "../src/include/connection.php";?>
<?php include "../src/classes/base.php";?>
<?php include "../src/classes/field.php";?>

<?php
$field = new Field($conn, 1);
$sql = $field->GetQuery(1);

echo "Testing Field.GetQuery():";
echo "<br>";
echo $sql;
$conn->close();
?>