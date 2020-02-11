<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/system.php";?>

<?php
    // Create instance
    $system = new System($conn, 1);
    $id_table = 1;

    $json = 
    '{
        "Session": 
        [
            {
                "Company": 1,                 
                "System": 1, 
                "Table": 1, 
                "User": 1          
            }
        ],    
        "Fields": 
        [
            {
                "Name": "id", 
                "Value": 999
            },            
            {
                "Name": "name", 
                "Value": "Produto 1"
            },
            {
                "Name": "expire_date", 
                "Value": "2020-01-01"
            },
            {
                "Name": "price", 
                "Value": "0.99"
            }
        ]
    }';

    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo $system->PrepareStatementForQuery($id_table, 1);
    echo $system->get_error();
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $system->PrepareStatementForInsert($id_table, $json);
    echo $system->get_error();    
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $system->PrepareStatementForUpdate($id_table, $json);
    echo $system->get_error();    
    echo "<br><br>";

    // Testing delete
    echo "Testing PrepareStatementForDelete():" . "<br>";
    echo $system->PrepareStatementForDelete($id_table, 1);
    echo $system->get_error();    
    echo "<br><br>";
?>