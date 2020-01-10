<?php 
    $resultset = $field->GetList(1);  
    $columns = $resultset->fetch_fields();    

    while ($row = $resultset->fetch_assoc()) {
        echo "<br>";
        echo "<label>" . $row["label"] . "</label>";
        echo "<input class='w3-input' type='text'>";
    }
?>