<?php
    // Included as plain code
    include "include/connection.php";
    // Class dependencies
    include "classes/base.php";
    include "classes/form.php";
    include "classes/field.php";
    include "classes/event.php";
    // Class instances
    $form = new Form($conn, 1);
    $field = new Field($conn, 1);
    $event = new Event($conn, 1);
    // Resultsets
    $rs_field = $field->GetList(1);
    $rs_event = $event->GetList(1);
    $rs_data = $field->GetData(1);
?>
