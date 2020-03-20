<?php

$json = '{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[]}';


$x = json_decode($json, true);

$x['session']['id_table'] = 99;
echo $x['session']['id_table'] = 99;



?>
