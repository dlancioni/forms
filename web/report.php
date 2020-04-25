<?php
    if ($tableId > 0) {
        if ($db->get_error() == "") {
            echo str_replace('|',"\"",$json->resultset->html);
        } else {
            echo $db->get_error();
        }
    }
?>   
