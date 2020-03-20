<?php include "../src/session.php";?>

<!DOCTYPE html>
<html>
<body>
<form id='Report' method='Post' action='form.php'>
    <!-- PAGE HEADER-->
    <?php include "header.php";?>
    <?php include "menu.php";?>
    <!-- PAGE CONTENTS-->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">

        <?php
        include "title.php";
        switch ($id_layout) {
            case 1: // table
                include "grid.php";
                include "paging.php";                
                break;
            case 2: // form
                include "field.php";
                break;
            default:
        }
        include "button.php";
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