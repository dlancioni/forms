<?php
include "db.php";
$db = new Db();
$json = '{"session":{"id_system":1,"id_table":2,"id_action":1}}';


$x = json_decode($json, true);
$x['session']['code'] = "alert('Hello World');";
echo $x['session']['code'];
$x = json_encode($x);
$x = str_replace("'", "''", $x);
$sql = "insert into tb_test (code) values ('{$x}')";
$data = $db->Query($sql)


?>
