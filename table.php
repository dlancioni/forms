<!DOCTYPE html>

<!-- BEGIN HTML -->
<html>
<body>

    <!-- HEADER include -->
    <?php include "web/header.php";?>
    <!-- PHP include -->
    <?php include "src/header.php";?>


    <!-- PAGE CONTENTS -->
    <div class="w3-container">
    <div class="w3-row">

        <div class="w3-col l12">
            <!-- Form name -->    
            <h3>
            <?php echo $form->getName();?>
            </h3>
            <hr>
            <!-- Main grid -->
            <?php include "table_grid.php";?>
        </div>    

        <button class="w3-button w3-black">Button Button</button>        

    </div>
    </div>

    <!-- Dynamic JS -->
    <script language="JavaScript">
    </script>

<!-- END HTML -->
</body>
</html>


