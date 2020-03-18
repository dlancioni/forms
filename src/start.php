<?php
    // Include dependencies
    include "exception.php";
    include "connection.php";

    // Start session
    session_start();

    // General Declaration
    $rs = "";
    $input = "";    
    $output = "";
    $id_layout = 0;
    $id_system = 1;
    $id_table = 0;

    try {

        // Requests
        if ($_GET["id_layout"] != null)
            $id_layout = $_GET["id_layout"];                    // from URL - 1 (table), 2 (form)
        if ($_GET["id_table"] != null)    
            $id_table = htmlspecialchars($_GET["id_table"]);    // from URL - table to usue

    } catch (exception $e) {

    }

?>
