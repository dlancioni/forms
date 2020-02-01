<?php

$json = 
'{
    "id_company": 1,
    "id_system": 1,
    "id_user": 1,        
    "id_table": 1,    
    "fields": 
    [
        {"name": "id", "value": 1},
        {"name": "ds", "value": "Produto xyz"}
    ]
}';

$obj = json_decode($json);
$items = $obj->{'fields'};

foreach ($items as $item) {
    echo $item->value;
}

?>