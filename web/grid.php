<?php 
    // Get data
    $input = '{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[]}';
    $data = $db->Execute($input);
    //echo "Erro: " . var_dump($data);
?>

<div class="w3-responsive">
    <table class="w3-table w3-striped w3-hoverable">
        <thead>
            <tr>
                <?php
                    pg_result_seek($table, 0);                
                    while ($column = pg_fetch_row($table)) {
                        echo "<th>" . $column[FIELD_LABEL] . "</th>";
                    }
                ?>
            </tr>
        </thead>

        <tbody>
            <?php
            foreach ($data as $item) {
                echo "<tr>";
                pg_result_seek($table, 0);           
                while ($column = pg_fetch_row($table)) {
                    $field = trim($column[FIELD_NAME]);                       
                    echo "<td>" . $item->$field . "</td>";
                }                  
                echo "</tr>";
            }
        ?>
        </tbody>
    </table>
</div>