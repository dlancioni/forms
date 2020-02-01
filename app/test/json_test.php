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
            "Value": 1
        },
        {
            "Name": "ds", 
            "Value": "Produto xyz"
        }
    ]
}';

$obj = json_decode($json);
$items = $obj->{'Fields'};

//echo var_dump($obj);


foreach ($items as $item) {
    echo $item->Value;
}

?>