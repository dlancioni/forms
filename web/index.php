<?php include "../src/page.php";?>

<!DOCTYPE html>
<html>
<body>

<!-- PAGE HEADER-->
<?php include "header.php";?>
<?php include "menu.php";?>

<!-- FORM -->
<form id='form1' name='form'>
    <!-- CURRENT SESSION -->
    <?php include "session.php";?>
    <!-- PAGE CONTENTS-->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">
        <?php
        switch ($target) {
            case "1": // report
                include "report.php";
                break;
            case "2": // form
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