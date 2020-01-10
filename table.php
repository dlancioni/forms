<!DOCTYPE html>

<!-- BEGIN HTML -->
<html>
<body>
<form id='Table' method='Post' action='form.php'>

    <!-- Header WEB -->
    <?php include "web/header.php";?>
    <!-- Header PHP -->
    <?php include "src/header.php";?>
    <!-- Menu PHP -->
    <?php include "menu.php";?>

    <!-- PAGE CONTENTS -->
    <div class="w3-row">

        <div class="w3-col l2">
            &nbsp;
        </div>

        <div class="w3-col l8">
            <!-- Title -->
            <?php include "title.php";?>
            <!-- Grid -->
            <?php include "table_grid.php";?>
            <!-- Button -->
            <?php include "table_button.php";?>
        </div>

        <div class="w3-col l2">
            &nbsp;
        </div>                

    </div>

    <!-- Dynamic JS -->
    <script language="JavaScript">
        function New(form) {

            //form.submit();	
            $('button').click(function() {
                $( "#Table" ).submit();
            });            
        }    




    </script>

    <!-- Footer WEB -->
    <?php include "web/footer.php";?>
    <!-- Footer PHP -->
    <?php include "web/footer.php";?>

<!-- END HTML -->
</form>
</body>
</html>


