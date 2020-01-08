<?php 
    $resultset = $field->PrepareStatementToQuery(1);  
    $columns = $resultset->fetch_fields();    
?>

<table class="ui striped table">
    <thead>
        <tr>
            <?php
                foreach ($columns as $column) {
                    echo "<th>$column->name</th>";
                }
            ?>
        </tr>
    </thead>

    <tbody>
        <?php
        while ($row = $resultset->fetch_assoc()) {
            echo "<tr>";
            foreach ($columns as $column) {
                echo "<td>";
                    echo $row[$column->name];
                echo "</td>";
            }
            echo "</tr>";
        }
    ?>
    </tbody>
</table>


