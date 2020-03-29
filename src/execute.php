<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";
    include "util.php";

    // Start session
    session_start();
   
    // General Declaration    
    $db = "";
    $sql = "";
    $fieldName = "";
    $fieldValue = "";    
    $jsonUtil = "";
    $json = "";

    try {

        // Instantiate objects
        $db = new Db();
        $jsonUtil = new JsonUtil();
        $json = $jsonUtil->getJson(1, 1, 1, 1);

        // Form contents to standard json
        foreach($_REQUEST as $key => $val) {
            $fieldName = trim($key);
            $fieldValue = trim($val);

            if (trim($fieldName) == "id") {
                if (!is_numeric($fieldValue)) {
                    $fieldValue = "0";
                }
            }

            $json = $jsonUtil->setField($json, $fieldName, $fieldValue);
        }

        // Persist it
        $sql = "call persist($1)";
        $json = $db->Execute($sql, $json);

    } catch (exception $e) {
        echo "EXCEPTION : " . $e;
    }

    echo $json->message;
    echo $db->get_error();
?>


