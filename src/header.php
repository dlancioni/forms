<?php

    // Included as plain code
    include "include/connection.php";

    // Class dependencies
    include "classes/transaction.php";
    
    // Class instances
    $transaction = new Transaction($conn, 1);
?>
