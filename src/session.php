<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "db.php";

    // Start session
    session_start();

    // General Declaration
    $sql = "";
    $rs = "";
    $input = "";    
    $output = "";
    $id_layout = 0;
    $id_system = 1;
    $id_table = 0;

    try {
        $db = new Db();

        // Requests
        if ($_GET["id_layout"] != null)
            $id_layout = $_GET["id_layout"];                    // from URL - 1 (table), 2 (form)
        if ($_GET["id_table"] != null)    
            $id_table = htmlspecialchars($_GET["id_table"]);    // from URL - table to usue

        // Keep the table structure
        $sql = "select * from vw_table where id_system = " . $id_system . "and id_table = " . $id_table;
        $table = $db->Query($sql);






    } catch (exception $e) {
            echo "ERRO EM START.PHP: " . $e;
    }

?>
