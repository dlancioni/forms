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
        <?php echo $transaction->getCompany();?>
    </div>

    <!-- Dynamic JS -->
    <script language="JavaScript">
    </script>

<!-- END HTML -->
</body>
</html>


