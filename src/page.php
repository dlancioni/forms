<?php
    // Start session
    session_start();

    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";
   
    // General Declaration
    $systemId = 1;    
    $targetId = 1; // 1-report 2-form
    $tableId = 1;
    $id = 1;
    $eventId = 0; // from tb_events (new, edit, delete, etc)

    $userId = 1;    
    $viewId = 0;
    $actionId = 0;
    $pageOffset = 0;    
    $json = "";
    $filter = [];
    $item = "";

    $fieldName = "";
    $fieldOperator = "";
    $fieldValue = "";

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Request data  
        if ($_REQUEST["__target__"] != null)
            $targetId = $_REQUEST["__target__"];
        if ($_REQUEST["__table__"] != null)
            $tableId = $_REQUEST["__table__"];
        if ($_REQUEST["__id__"] != null)
            $id = $_REQUEST["__id__"];
        if ($_REQUEST["__event__"] != null)
            $eventId = $_REQUEST["__event__"];
        if ($_REQUEST["__offset__"] != null)
            $pageOffset = $_REQUEST["__offset__"];            

        // Get data for current system and table
        $json = $jsonUtil->setSession($json, "id_system", $systemId);
        $json = $jsonUtil->setSession($json, "id_table", $tableId);
        $json = $jsonUtil->setSession($json, "id", $id);
        $json = $jsonUtil->setSession($json, "id_event", $eventId);
        $json = $jsonUtil->setSession($json, "page_offset", $pageOffset);

        // Filter logic
        if ($eventId == 6) {
            foreach($_REQUEST as $key => $val) {
                if (isValid($fieldName) == "true") {
                    $fieldName = trim($key);
                    $fieldValue = trim($val);

                    //
                    if (strpos($fieldName, "_operator") > 0) {
                        $fieldOperator = $fieldValue;
                    } else {                        
                        if (trim($fieldValue) != "" && trim($fieldValue) != "0") {
                            if ($fieldOperator == "0") {$fieldOperator = "=";}
                            $item = ["field_name" => $fieldName, "operator" => $fieldOperator, "field_value" => $fieldValue];
                            array_push($filter, $item);
                        }
                    }
                    //    

                }
            }
            $json = $jsonUtil->setFilter($json, $filter);
        }        

        // Debug point to check what is been sent to bd
        echo $json;

        if ($targetId == 1) {
            $sql = "call report($1)";
        } else {
            $sql = "call form($1)";
        }

        $json = $db->Execute($sql, $json);  

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

    function isValid($item) {

        switch ($item) {
            case "__target__":
            case "__table__":
            case "__id__":
            case "__event__":
            case "__offset__":
                return "false";
            default:
                return "true";    
        }
    }

?>
