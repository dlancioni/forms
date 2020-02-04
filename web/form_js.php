<script language="JavaScript">
<?php 
    // tb_event_for: 1-report
    while ($row = $rs_event->fetch_assoc()) {
        if ($row["id_event_for"] == 2) {
            echo $row["function_code"];
            echo "<br>";
        }
    }
?>
</script>