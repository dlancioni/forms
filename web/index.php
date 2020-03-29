<?php include "../src/session.php";?>

<!DOCTYPE html>
<html>
<body>
<form id='form1' name='form1' method='Post'>

    <!-- USER SESSION -->
    <input id="page_offset" name="page_offset" type="hidden" value="0">
    <input id="id_table" name="id_table" type="hidden" value="<?php echo $tableId; ?>">
    <input id="id_target" name="id_target" type="hidden" value="<?php if ($targetId==1) {echo "2";} else {echo 1;} ?>">


    <!-- PAGE HEADER-->
    <?php include "header.php";?>
    <?php include "menu.php";?>
    <!-- PAGE CONTENTS-->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">
        <?php
        switch ($targetId) {
            case 1: // table
                include "grid.php";
                break;
            case 2: // form
                include "field.php";
                break;
            default:
        }
        ?>
        </div>
        <div class="w3-col l2">&nbsp;</div>
    </div>
    <!-- PAGE FOOTER-->    
    <?php include "js.php";?>
    <?php include "footer.php";?>
</form>
</body>
</html>