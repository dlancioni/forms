<?php 
    $resultset = $field->PrepareStatementToQuery(1);  
    $columns = $resultset->fetch_fields();    
?>

<div class="w3-responsive">
    <table class="w3-table w3-striped w3-hoverable">
        <thead>
            <tr>
                <?php
                    foreach ($columns as $column) {
                        if ($column->name != "Id") {                        
                            echo "<th>$column->name</th>";
                        }
                    }
                ?>
            </tr>
        </thead>

        <tbody>
            <?php
            while ($row = $resultset->fetch_assoc()) {
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
        ?>
        </tbody>
    </table>
</div>

