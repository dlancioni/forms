<?php

class JsonUtil {

    function __construct() {
    }

    // Error handling    
    function setSession($json, $field, $value) {
        $json = json_decode($json, true);
        $json['session'][$field] = $value;
        $json = json_encode($json);
        return $json;
    }
}

?>
