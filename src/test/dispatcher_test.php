<?php include "../include/exception.php";?>
<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/dispatcher.php";?>

<?php
    // Create instance
    $obj = new Dispatcher($conn, 1);
    $id_table = 1;
    $json = '{"data": {"name": "lancioni it", "price": 1200, "expire_date": "2021-01-01"}, "session": {"action": "I", "id_table": 1, "id_system": 1, "id_company": 1}}';
    
    echo "******************************** COMPANY ********************************<br><br>";
    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo "SQL: " . $obj->PrepareStatementForQuery($json) . "<br>";
    echo "Count: " . $obj->Query($json)->num_rows . "<br>";
    echo "Error: " . $obj->get_error() . "<br>";
    echo "<br><br>";
?>