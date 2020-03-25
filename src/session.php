<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";

    // Start session
    session_start();
   
    // General Declaration
    $pageOffset = 0;
    $targetId = 0;
    $systemId = 1;
    $tableId = 2;
    $viewId = 0;
    $data = "";
    $json = '{"session":{"id_system":0,"id_table":0},"filter":[]}';

    try {
        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Requests
        if ($_GET["id_target"] != null)
            $targetId = $_GET["id_target"];
        if ($_GET["id_table"] != null)
            $tableId = htmlspecialchars($_GET["id_table"]);
        if ($_GET["page_offset"] != null)
            $pageOffset = $_GET["page_offset"];

        // Get data for current system and table
        $json = $jsonUtil->setSession($json, "id_system", $systemId);
        $json = $jsonUtil->setSession($json, "id_table", $tableId);
        $json = $jsonUtil->setSession($json, "page_offset", $pageOffset);
        
        if ($targetId == 1) {
            $sql = "call report($1)";
        } else {
            $sql = "call form($1)";
        }
        $data = $db->Execute($sql, $json);  


    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

?>
