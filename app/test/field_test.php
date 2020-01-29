<?php include "../src/include/connection.php";?>
<?php include "../src/classes/base.php";?>
<?php include "../src/classes/field.php";?>

<?php
    // Create instance
    $field = new Field($conn, 1);

    $json = 
    '{
        "id_company": 1,
        "id_system": 1,
        "id_user": 1,        
        "id_table": 1,    
        "fields": [
            {"name": "id", "value": 1}
            {"name": "ds", "value": "Produto xyz"},
        ]
    }';

    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo $field->PrepareStatementForQuery(1, 0);
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $field->PrepareStatementForInsert(1, $data);
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $field->PrepareStatementForUpdate(1, $data);
    echo "<br><br>";

    // Testing delete
    echo "Testing PrepareStatementForDelete():" . "<br>";
    echo $field->PrepareStatementForDelete(1, 1);
    echo "<br><br>";
?>