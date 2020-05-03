<?php

class JsonUtil {

    function __construct() {
    }

    function getJson($system, $table, $user, $action) {
        $json = "";
        $json = $this->setSession($json, "id_system", intval($system));
        $json = $this->setSession($json, "id_table", intval($table));
        $json = $this->setSession($json, "id_user", intval($user));
        $json = $this->setSession($json, "id_action", intval($action));
        $json = $this->setField($json, "id", intval("0"));
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
