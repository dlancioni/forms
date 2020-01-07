<!DOCTYPE html>

<!-- BEGIN HTML -->
<html>
<body>

    <!-- HEADER include -->
    <?php include "php/include/header.php";?>

    <!-- PHP include -->
    <?php include "php/classes/transaction.class";?>
    <?php
        $table = new Table($conn, 1);
    ?>

    <!-- PAGE CONTENTS -->
    <div class="ui segment">
        <?php echo $table->get_name();?>
    </div>

    <!-- Dynamic JS -->
    <script language="JavaScript">
    </script>

<!-- END HTML -->
</body>
</html>


