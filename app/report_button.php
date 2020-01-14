<br>
<?php 
    $resultset = $event->GetList(1);
    while ($row = $resultset->fetch_assoc()) {
        echo "<button class='w3-button w3-blue'>" . $row["label"] . "</button>";
    }
?>