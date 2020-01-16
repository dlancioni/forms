<br>
<?php 
    while ($row = $rs_event->fetch_assoc()) {
        if ($row["id_event_for"] == 2) {
            echo "<button class='w3-button w3-blue'>" . $row["label"] . "</button>";
        }
    }
?>