<?php include "../include/exception.php";?>
<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/system.php";?>

<?php


try {
    $foo = 1/0;
} catch (Exception $e) {
    //var_dump($e->getTrace());
    echo $e->getMessage();
}

?>