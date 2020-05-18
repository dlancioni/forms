<?php
    // Start session
    session_start();

    // Include dependencies
    include "exception.php";
    include "db.php";
    include "util.php";
    include "filter.php";    
   
    // Session control
    $json = "";
    $session = "";
    $field = "";    

    // Filter related
    $filter = [];
    $item = "";
    $fieldName = "";
    $fieldOperator = "";
    $fieldValue = "";

    // Form or report output
    $html = "";    

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();
        $filter = new Filter();

        // Update the session
        $json = $_SESSION['SESSION'];
        if (isset($_REQUEST['id']))
            $json = $jsonUtil->setField($json, "id", $_REQUEST['id']);
        if (isset($_REQUEST['id_page']))
            $json = $jsonUtil->setSession($json, "id_page", $_REQUEST['id_page']);
        if (isset($_REQUEST['id_table']))
            $json = $jsonUtil->setSession($json, "id_table", $_REQUEST['id_table']);
        if (isset($_REQUEST['id_event']))
            $json = $jsonUtil->setSession($json, "id_event", $_REQUEST['id_event']);
        if (isset($_REQUEST['page_offset']))
            $json = $jsonUtil->setSession($json, "page_offset", $_REQUEST['page_offset']);
        $_SESSION['SESSION'] = $json;

        // Filter logic	
        $json = $filter->getFilter($json);
        
        // Log in screen
        // echo $json;

        // Make data available    
        $json = json_decode($json, true);
        $session = $json['session'];
        $field = $json['field'];

        // Debug point to check what is been sent to bd
        if ($session['id_page'] == "1") {
            $sql = "call html_table($1)";
        } else {
            $sql = "call html_form($1)";
        }

        $db->set_return_type("html");
        $html = $db->Execute($sql, json_encode($json));

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

?>
