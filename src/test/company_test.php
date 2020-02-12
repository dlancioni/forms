<?php include "../include/exception.php";?>
<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/company.php";?>

<?php
    // Create instance
    $obj = new Company($conn, 1);
    $id_table = 1;
    $json = '{"Session": {"id_company": 1, "id_system": 1, "id_table": 1, "id_user": 1}, "Fields": {"id": 1, "name": "Taza Inc", "expire_date": "2020-01-01", "price": "0.99"}}';
    
    echo "******************************** COMPANY ********************************<br><br>";
    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo "SQL: " . $obj->PrepareStatementForQuery($json) . "<br>";
    echo "Count: " . $obj->Query($json)->num_rows . "<br>";
    echo "Error: " . $obj->get_error() . "<br>";
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $obj->PrepareStatementForInsert($json);
    echo $obj->get_error();    
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $obj->PrepareStatementForUpdate($json);
    echo $obj->get_error();    
    echo "<br><br>";

    // Testing delete
    echo "Testing PrepareStatementForDelete():" . "<br>";
    echo $obj->PrepareStatementForDelete($json);
    echo $obj->get_error();    
    echo "<br><br>";
?>