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

$obj = json_decode($json)->{'Fields'}[0]->Value;
echo $obj;
//echo $obj[0]->Value;


?>