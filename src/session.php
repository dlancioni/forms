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
    $id_layout = 0;
    $id_system = 1;
    $id_table = 2;
    $id_view = 0;
    $data = "";
    $json = '{"session":{"id_system":0,"id_table":0},"filter":[]}';

    try {
        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();

        // Requests
        if ($_GET["id_layout"] != null)
            $id_layout = $_GET["id_layout"];
        if ($_GET["id_table"] != null)
            $id_table = htmlspecialchars($_GET["id_table"]);
        if ($_GET["page_offset"] != null)
            $pageOffset = $_GET["page_offset"];

        // Get data for current system and table
        $json = $jsonUtil->setSession($json, "id_system", $id_system);
        $json = $jsonUtil->setSession($json, "id_table", $id_table);
        $json = $jsonUtil->setSession($json, "page_limit", PAGE_SIZE);
        $json = $jsonUtil->setSession($json, "page_offset", $pageOffset);
        
        if ($id_layout == 1) {
            $sql = "call query($1)";
        } else {
            $sql = "call form($1)";
        }
        $data = $db->Execute($sql, $json);  


    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

?>
