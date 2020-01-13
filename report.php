<!DOCTYPE html>
<!-- BEGIN HTML -->
<html>
<body>
<form id='Report' method='Post' action='form.php'>

    <!-- HEADER -->
    <?php include "web/header.php";?>
    <?php include "src/header.php";?>
    <?php include "menu.php";?>

    <!-- CONTENTS -->
    <div class="w3-row">
        <div class="w3-col l2">&nbsp;</div>
        <div class="w3-col l8">
            <?php include "title.php";?>
            <?php include "report_grid.php";?>
            <?php include "report_button.php";?>
        </div>
        <div class="w3-col l2">&nbsp;</div>
    </div>

    <!-- JS -->
    <script language="JavaScript">
        function New(form) {
            $('button').click(function() {
                $( "#Report" ).submit();
            });            
        }    
    </script>

    <!-- FOOTER -->
    <?php include "web/footer.php";?>
    <?php include "web/footer.php";?>

<!-- END HTML -->
</form>
</body>
</html>