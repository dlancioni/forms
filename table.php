<!DOCTYPE html>

<!-- BEGIN HTML -->
<html>
<body>

    <!-- HEADER include -->
    <?php include "web/header.php";?>
    <!-- PHP include -->
    <?php include "src/header.php";?>


    <!-- PAGE CONTENTS -->
    <div class="ui segment">

        <!-- Form name -->    
        <?php echo $form->getName();?>

        <!-- Main grid -->
        <?php include "table_grid.php";?>

    </div>

    <!-- Dynamic JS -->
    <script language="JavaScript">
    </script>

<!-- END HTML -->
</body>
</html>


