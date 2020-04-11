<?php

class JsonUtil {

    function __construct() {
    }

    function getJson($system, $table, $user, $action) {

        $json = "";
        $json = $this->setSession($json, "id_system", $system);
        $json = $this->setSession($json, "id_table", $table);
        $json = $this->setSession($json, "id_user", $user);
        $json = $this->setSession($json, "id_action", $action);

        $json = $this->setField($json, "id", "0");

        return $json;
    }

    function setSession($json, $field, $value) {
        $json = json_decode($json, true);
        $json['session'][$field] = $value;
        $json = json_encode($json);
        return $json;
    }

    function setField($json, $field, $value) {
        $json = json_decode($json, true);
        $json['field'][$field] = $value;
        $json = json_encode($json);
        return $json;
    }

    function setFilter($json, $filter) {
        $json = json_decode($json, true);
        $json['filter'] = $filter;
        $json = json_encode($json);
        return $json;
    }

}


?>
