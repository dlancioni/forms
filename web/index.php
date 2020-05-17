<?php include "../src/page.php";?>

<!DOCTYPE html>
<html>
<body>

<!-- PAGE HEADER-->
<?php include "header.php";?>
<?php include "menu.php";?>

<!-- FORM -->
<form id='form1' name='form'>

    <!-- Control flow on js side -->
    <input type="text" id="id_page" value="<?php if (isset($_REQUEST['id_page'])) echo $_REQUEST['id_page'] ?>">
    <input type="text" id="id_table" value="<?php if (isset($_REQUEST['id_table'])) echo $_REQUEST['id_table'] ?>">
    <input type="text" id="id_event" value="<?php if (isset($_REQUEST['id_event'])) if (isset($_REQUEST['id'])) $_REQUEST['id_event'] ?>">
    <input type="text" id="id" value="<?php if (isset($_REQUEST['id'])) echo $_REQUEST['id'] ?>">    
    <input type="text" id="page_offset" value="<?php if (isset($_REQUEST['page_offset'])) echo $_REQUEST['page_offset'] ?>">

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