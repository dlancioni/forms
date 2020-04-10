<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";

    // Start session
    session_start();
   
    // General Declaration    
    $systemId = 1;
    $tableId = 0;
    $userId = 1;
    $eventId = 0;
    $actionId = 0;

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
        $eventId = $_REQUEST["id_event"];
        $tableId = $_REQUEST["id_table"];

        // Transform the event in action
        switch ($eventId) {
            case 1:                 // new->insert    
                $actionId = 1;
                break;
            case 2:                 // edit->update
                $actionId = 2;
                break;                
            case 3:                 // Delete button
                $actionId = 3;
                break;                
        } 

        // Get representation of current action
        $json = $jsonUtil->getJson($systemId, $tableId, $userId, $actionId);

        // Form contents to standard json
        foreach($_REQUEST as $key => $val) {

            // kEEP THE VALUES
            $fieldName = trim($key);
            $fieldValue = trim($val);

            // Must set 0 if ID is not informed    
            if (trim($fieldName) == "id_record") {
                if ($actionId != 1) {
                    $json = $jsonUtil->setField($json, "id", $fieldValue);
                } else {
                    $json = $jsonUtil->setField($json, "id", 0);                    
                }
            }
            $json = $jsonUtil->setField($json, $fieldName, $fieldValue);
        }

        // Persist it
        $log = $json;
        $sql = "call persist($1)";
        $json = $db->Execute($sql, $json);

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

    //echo $log;
    echo $json->message;

?>


