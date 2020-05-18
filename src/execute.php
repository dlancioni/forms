<?php
    // Include dependencies
    include "exception.php";
    include "db.php";
    include "util.php";

    // Start session
    session_start();

    $db = "";
    $sql = "";
    $fieldName = "";
    $fieldValue = "";    
    $jsonUtil = "";
    $json = "";
    $session = "";
    $log = "";

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Get current session   
        $json = $_SESSION['SESSION'];
        $session = $_SESSION['SESSION'];

        // Let session available for read
        $session = json_decode($json, true);
        $session = $session['session'];

        // Form contents to standard json
        foreach($_REQUEST as $key => $val) {
            $fieldName = trim($key);
            $fieldValue = trim($val);
            if (isValid($fieldName) == "true") {            
                if (trim($fieldName) == "id") {
                    if ($session['id_event'] != 1) { // new
                        $json = $jsonUtil->setField($json, "id", intval($fieldValue));
                    } else {
                        $json = $jsonUtil->setField($json, "id", 0);
                    }
                }
                $json = $jsonUtil->setField($json, $fieldName, $fieldValue);
            }
        }

        // Handle single quote
        $json = str_replace("'", "''", $json);

        // Persist it
        $sql = "select persist($1)";
        $db->set_return_type("json");
        $json = $db->Execute($sql, $json);

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

    //echo db->get_error();
    echo $json->message;

    function isValid($item) {

        switch ($item) {
            case "__target__":
            case "__table__":
            case "__event__":
            case "__offset__":
                return "false";
            default:
                return "true";    
        }
    }


?>


