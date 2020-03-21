<div class="w3-responsive">
    <table class="w3-table w3-striped w3-hoverable">
        <thead>
            <tr>
                <td></td>
                <?php
                    if ($table) {
                        pg_result_seek($table, 0);                
                        while ($column = pg_fetch_row($table)) {
                            echo "<th>" . $column[FIELD_LABEL] . "</th>";
                        }
                    }
                ?>
            </tr>
        </thead>

        <tbody>
            <?php
            if ($data && $table) {
                foreach ($data as $item) {
                    pg_result_seek($table, 0);
                    echo "<tr>";
                    echo "<td><input type='radio' id='" . $item->id . "' name='selection' value=''></td>";
                    while ($column = pg_fetch_row($table)) {
                        $field = trim($column[FIELD_NAME]);
                        echo "<td>" . $item->$field . "</td>";
                    }
                    echo "</tr>";
                }
            }            
        ?>
        </tbody>
    </table>
</div>
