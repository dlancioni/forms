<?php
    // Included as plain code
    include "include/connection.php";

    // Class dependencies
    include "classes/base.php";    
    include "classes/form.php";
    include "classes/field.php";

    // Class instances
    $form = new Form($conn, 1);
    $field = new Field($conn, 1);
?>
