<?php 
    include "../src/page.php";
?>

<!DOCTYPE html>
<html>
<body>

<!-- PAGE HEADER-->
<?php include "header.php";?>
<?php include "menu.php";?>

<!-- FORM -->
<form id='form1' name='form'>

    <!-- Control flow on js side -->
    <input type="hidden" id="id_page" name="id_page" value="<?php echo $session['id_page']; ?>">
    <input type="hidden" id="id_table" name="id_table" value="<?php echo $session['id_table']; ?>">
    <input type="hidden" id="id_event" name="id_event" value="<?php echo $session['id_event']; ?>">
    <input type="hidden" id="id" name="id" value="<?php echo $field['id']; ?>">
    <input type="hidden" id="page_offset" name="page_offset" value="<?php echo $session['page_offset']; ?>">

    <!-- PAGE CONTENTS-->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">
        <?php

        switch ($session['id_page']) {
            case "1":
                include "report.php";
                break;
            case "2":
                include "form.php";
                break;
            default:
                echo "Invalid target";
        }

        ?>
        </div>
        <div class="w3-col l2">&nbsp;</div>
    </div>
</form>

<!-- PAGE FOOTER-->    
<?php include "js.php";?>
<?php include "footer.php";?>

</body>
</html>