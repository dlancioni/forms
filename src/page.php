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
    $recordId = 1;
    $eventId = 0; // from tb_events (new, edit, delete, etc)

    $userId = 1;    
    $viewId = 0;
    $actionId = 0;
    $pageOffset = 0;    
    $json = '';

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Request data  
        if ($_REQUEST["id_target"])
            $targetId = $_REQUEST["id_target"];
        if ($_REQUEST["id_table"])
            $tableId = $_REQUEST["id_table"];
        if ($_REQUEST["id_record"])
            $recordId = $_REQUEST["id_record"];
        if ($_REQUEST["id_event"])
            $eventId = $_REQUEST["id_event"];
        if ($_REQUEST["page_offset"])
            $pageOffset = $_REQUEST["page_offset"];

        // Get data for current system and table
        $json = $jsonUtil->setSession($json, "id_system", $systemId);
        $json = $jsonUtil->setSession($json, "id_table", $tableId);
        $json = $jsonUtil->setSession($json, "id", $recordId);
        $json = $jsonUtil->setSession($json, "id_event", $eventId);
        $json = $jsonUtil->setSession($json, "page_offset", $pageOffset);

        // Debug point to check what is been sent to bd
        //echo $json;
        
        if ($targetId == 1) {
            $sql = "call report($1)";
        } else {
            $sql = "call form($1)";
        }

        $json = $db->Execute($sql, $json);  

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

?>
