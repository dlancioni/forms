<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";

    // Start session
    session_start();
   
    // General Declaration    
    $system = 1;
    $table = 0;
    $user = 1;
    $event = 0;
    $action = 0;

    $db = "";
    $sql = "";
    $fieldName = "";
    $fieldValue = "";    
    $jsonUtil = "";
    $json = "";
    $log = "";

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Request key fields
        $event = intval($_REQUEST["__event__"]);
        $table = intval($_REQUEST["__table__"]);

        // Transform the event in action
        switch ($event) {
            case 1:                 // new->insert    
                $action = 1;
                break;
            case 2:                 // edit->update
                $action = 2;
                break;                
            case 3:                 // Delete button
                $action = 3;
                break;                
        } 

        // Get representation of current action
        $json = $jsonUtil->getJson($system, $table, $user, $action);

        // Form contents to standard json
        foreach($_REQUEST as $key => $val) {

            // Keep the values
            $fieldName = trim($key);
            $fieldValue = trim($val);
            if (isValid($fieldName) == "true") {            
                // Must set 0 if ID is not informed    
                if (trim($fieldName) == "__id__") {
                    if ($action != 1) { // new
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
        $log = $json;
        $sql = "select persist($1)";
        $db->set_return_type("json");
        $json = $db->Execute($sql, $json);

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

    error_log($log);
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


