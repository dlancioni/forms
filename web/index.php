<?php include "../src/declare.php";?>

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
        <a href="table.php">table</a>
        <a href="form.php">form</a>
        </div>
        <div class="w3-col l2">&nbsp;</div>
    </div>
    <!-- PAGE FOOTER-->    
    <?php include "js.php";?>
    <?php include "footer.php";?>
</form>
</body>
</html>

<?php include "../src/release.php";?>