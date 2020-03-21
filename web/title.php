<!-- Table or Form name -->    
<h3>
<?php
    if ($table) {
        pg_result_seek($table, 0);
        while ($column = pg_fetch_row($table)) {
            echo $column[TABLE_NAME];
            break;
        }
    }
?>
</h3>