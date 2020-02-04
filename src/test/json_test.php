<?php

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
            "Name": "id", 
            "Value": 1
        },
        {
            "Name": "ds", 
            "Value": "Produto xyz"
        }
    ]
}';

$obj = json_decode($json)->{'Fields'}[0]->Value;
echo $obj;
//echo $obj[0]->Value;


?>