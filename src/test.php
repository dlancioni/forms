<?php
include "db.php";
$db = new Db();
$json = '{"session":{"id_system":1,"id_table":2,"id_action":1}}';





$json = "";
$json = json_decode($json, true);
$json['field_name'] = "id";
$json['operator'] = "=";
$json['field_value'] = "123";

$item1 = 
[
    "region" => "valore",
    "price" => "valore2"
];
$item2 = 
[
    "region" => "valore",
    "price" => "valore2"
];

$arr = [];

array_push($arr, $item1);
array_push($arr, $item2);



echo json_encode($arr);




?>
