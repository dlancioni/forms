<?php
    // Start session
    session_start();

    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";
   
    // General Declaration
    $system = 1;    
    $target = 1; // 1-report 2-form
    $table = 1;
    $record = 1;
    $event = 0; // from tb_events (new, edit, delete, etc)

    $user = 1;    
    $view = 0;
    $action = 0;
    $pageOffset = 0;    
    $json = "";
    $html = "";
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
            $target = $_REQUEST["__target__"];
        if ($_REQUEST["__table__"] != null)
            $table = $_REQUEST["__table__"];
        if ($_REQUEST["__id__"] != null)
            $record = $_REQUEST["__id__"];
        if ($_REQUEST["__event__"] != null)
            $event = $_REQUEST["__event__"];
        if ($_REQUEST["__offset__"] != null)
            $pageOffset = $_REQUEST["__offset__"];            

        // Get data for current system and table
        $json = $jsonUtil->setSession($json, "id_system", intval($system));
        $json = $jsonUtil->setSession($json, "id_table", intval($table));
        $json = $jsonUtil->setSession($json, "id", intval($record));
        $json = $jsonUtil->setSession($json, "id_event", intval($event));
        $json = $jsonUtil->setSession($json, "page_offset", intval($pageOffset));

        // Filter logic
        if ($event == 6) {
            foreach($_REQUEST as $key => $val) {
                $fieldName = trim($key);
                $fieldValue = trim($val);
                if (isValid($fieldName) == "true") {
                    if (strpos($fieldName, "_operator") > 0) {
                        $fieldOperator = $fieldValue;
                    } else {                        
                        if (trim($fieldValue) != "" && trim($fieldValue) != "0") {
                            if ($fieldOperator == "0") {$fieldOperator = "=";}
                            $item = ["field_name" => $fieldName, "operator" => $fieldOperator, "field_value" => $fieldValue];
                            array_push($filter, $item);
                        }
                    }
                }
            }
            $json = $jsonUtil->setFilter($json, $filter);
        }        

        // Debug point to check what is been sent to bd
        // echo $json;

        if ($target == "report") {
            $sql = "call html_table($1)";
        } else {
            $sql = "call html_form($1)";
        }

        $db->set_return_type("html");
        $html = $db->Execute($sql, $json);  

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
