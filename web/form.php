<!DOCTYPE html>

<!-- BEGIN HTML -->
<html>
<body>
<form id='Form' method='Post' action='report.php'>
    <!-- HEADER -->
    <?php include "web/header.php";?>
    <?php include "src/header.php";?>
    <?php include "menu.php";?>
    <!-- PAGE CONTENTS -->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">
            <?php include "title.php";?>
            <?php include "form_field.php";?>
            <?php include "form_button.php";?>            
        </div>
        <div class="w3-col l2">&nbsp;</div>
    </div>
    <!-- JS -->
    <?php include "form_js.php";?>
    <!-- FOOTER -->
    <?php include "web/footer.php";?>
    <?php include "web/footer.php";?>
<!-- END HTML -->
</form>
</body>
</html>


