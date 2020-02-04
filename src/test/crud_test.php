<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/system.php";?>

<?php
    // Create instance
    $crud = new Crud($conn, 1);
    $id_system = 1;

    $json = 
    '{
        "Session": 
        [
            {
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
                "Name": "num_1", 
                "Value": 1
            },
            {
                "Name": "tex_1", 
                "Value": "Produto xyz"
            },
            {
                "Name": "dat_1", 
                "Value": "2020-01-01"
            },
            {
                "Name": "dec_1", 
                "Value": "0.99"
            }            
        ]
    }';

    // Testing query
    echo "Testing PrepareStatementForQuery():" . "<br>";
    echo $crud->PrepareStatementForQuery($id_system, 0);
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $crud->PrepareStatementForInsert($id_system, $json);
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $crud->PrepareStatementForUpdate($id_system, $json);
    echo "<br><br>";

    // Testing delete
    echo "Testing PrepareStatementForDelete():" . "<br>";
    echo $crud->PrepareStatementForDelete($id_system, 1);
    echo "<br><br>";
?>