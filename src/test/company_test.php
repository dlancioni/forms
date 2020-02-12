<?php include "../include/exception.php";?>
<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/company.php";?>

<?php
    // Create instance
    $obj = new Company($conn, 1);
    $id_table = 1;
    $json = '{"Session": {"Company": 1, "System": 1, "Table": 1, "User": 1}, "Fields": {"id": 1, "name": "Taza Inc", "expire_date": "2020-01-01", "price": "0.99"}}';


    echo "******************************** COMPANY ********************************<br><br>";


    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo $obj->PrepareStatementForQuery($id_table, 1);
    echo $obj->get_error();
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $obj->PrepareStatementForInsert($id_table, $json);
    echo $obj->get_error();    
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $obj->PrepareStatementForUpdate($id_table, $json);
    echo $obj->get_error();    
    echo "<br><br>";

    // Testing delete
    echo "Testing PrepareStatementForDelete():" . "<br>";
    echo $obj->PrepareStatementForDelete($id_table, 1);
    echo $obj->get_error();    
    echo "<br><br>";
?>