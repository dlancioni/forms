<?php 
    try {

        // Get data
        $input = '{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}';
        $output = pg_query_params($conn, 'call query($1)', array($input));
        while ($row = pg_fetch_row($output)) {
            if ($row[0]) {
                $rs = json_decode($row[0])->resultset;
            }
        }
        echo $rs[0]->name;
    } catch (exception $e) {
        echo "deu pau";
            echo $e;
    }

?>

<div class="w3-responsive">
    <table class="w3-table w3-striped w3-hoverable">
        <thead>
            <tr>
                <?php
                    /*
                    foreach ($columns as $column) {
                        if ($column->name != "Id") {                        
                            echo "<th>$column->name</th>";
                        }
                    }
                    */
                ?>
            </tr>
        </thead>

        <tbody>
            <?php
            /*
            while ($row = $rs_data->fetch_assoc()) {
                echo "<tr>";
                foreach ($columns as $column) {
                    if ($column->name != "Id") {
                        echo "<td>";
                        echo $row[$column->name];
                        echo "</td>";
                    }
                }
                echo "</tr>";
            }
            */






        ?>
        </tbody>
    </table>
</div>