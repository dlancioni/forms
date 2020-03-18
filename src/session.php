<?php
    // Include dependencies
    include "constants.php";
    include "exception.php";
    include "connection.php";

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

        // Requests
        if ($_GET["id_layout"] != null)
            $id_layout = $_GET["id_layout"];                    // from URL - 1 (table), 2 (form)
        if ($_GET["id_table"] != null)    
            $id_table = htmlspecialchars($_GET["id_table"]);    // from URL - table to usue

        // Keep the table structure
        $sql = "select * from vw_table where id_system = $1 and id_table = $2";
        $table = pg_query_params($conn, $sql, array($id_system, $id_table));

    } catch (exception $e) {
            echo "ERRO EM START.PHP: " . $e;
    }

?>
