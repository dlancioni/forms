<?php
    if ($session['id_table'] > 0) {
        if ($db->get_error() == "") {
            echo $html;
        } else {
            echo $db->get_error();
        }
    }
?>   
