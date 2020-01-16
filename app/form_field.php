<?php 
    while ($row = $rs_field->fetch_assoc()) {

        if ($row["name"] != "id") {
            echo "<br>";
            echo "<label>" . $row["label"] . "</label>";
            echo "<input class='w3-input' type='text'>";
        }
    }
?>