<?php

$json = '{"Session": {"Company": 1, "System": 1, "Table": 1, "User": 1}, "Fields": {"id": 1, "name": "Taza Inc", "expire_date": "2020-01-01", "price": "0.99"}}';
$obj = json_decode($json);

$date="expire_date";
//echo var_dump($obj);
echo $obj->Fields->$date;

?>