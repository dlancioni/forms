<?php include "../src/include/connection.php";?>
<?php include "../src/classes/base.php";?>
<?php include "../src/classes/field.php";?>

<?php
    // Create instance
    $field = new Field($conn, 1);

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
    echo $field->PrepareStatementForQuery(1, 0);
    echo "<br><br>";

    // Testing insert
    echo "Testing PrepareStatementForInsert():" . "<br>";
    echo $field->PrepareStatementForInsert(1, $json);
    echo "<br><br>";

    // Testing update
    echo "Testing PrepareStatementForUpdate():" . "<br>";
    echo $field->PrepareStatementForUpdate(1, $json);
    echo "<br><br>";

    // Testing delete
    //echo "Testing PrepareStatementForDelete():" . "<br>";
    //echo $field->PrepareStatementForDelete(1, 1);
    //echo "<br><br>";
?>