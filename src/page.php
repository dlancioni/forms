<?php
    // Start session
    session_start();

    // Include dependencies
    include "exception.php";
    include "db.php";
    include "util.php";
   
    // Session control
    $json = "";
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

        // Update the session
        $json = $_SESSION['SESSION'];        
        if (isset($_REQUEST['id_page']))        
            $json = $jsonUtil->setSession($json, "id_page", $_REQUEST['id_page']);
        if (isset($_REQUEST['id_table']))
            $json = $jsonUtil->setSession($json, "id_table", $_REQUEST['id_table']);
        if (isset($_REQUEST['id_event']))
            $json = $jsonUtil->setSession($json, "id_event", $_REQUEST['id_event']);
        if (isset($_REQUEST['id']))
            $json = $jsonUtil->setSession($json, "id_event", $_REQUEST['id']);
        $_SESSION['SESSION'] = $json;
        echo $json;
        
        // Make data available    
        $json = json_decode($json, true);
        $session = $json['session'];

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
