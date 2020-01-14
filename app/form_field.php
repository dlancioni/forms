<?php 
    $resultset = $field->GetList(1);  

    while ($row = $resultset->fetch_assoc()) {

        if ($row["name"] != "id") {
            echo "<br>";
            echo "<label>" . $row["label"] . "</label>";
            echo "<input class='w3-input' type='text'>";
        }
    }
?>