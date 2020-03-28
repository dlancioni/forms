<?php include "../src/session.php";?>

<!DOCTYPE html>
<html>
<body>
<form id='form1' name='form1' method='Post'>
    <input id="id_table" type="hidden" value="<?php echo $tableId; ?>">
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
    <?php include "footer.php";?>
</form>
</body>
</html>