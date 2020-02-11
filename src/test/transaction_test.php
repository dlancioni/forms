<?php include "../include/exception.php";?>
<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/company.php";?>

<?php


try {
    // set autocommit to off
    $conn->autocommit(FALSE);    

    // Insert some values
    // Insert some values
    $sql = "drop table tb_langaugee";
    $conn->query($sql);
    if($conn->error != "") throw new Exception($conn->error);    

    // Insert some values
    $sql = "insert into tb_language (name) values ('English')";
    $conn->query($sql);

    // Commit
    echo "before commit";     
    $conn->commit();    

    // Fail
    echo "Success";    
    
} catch (Exception $ex) {

    // Rollback    
    $conn->rollback();

    // Fail
    echo $ex->getMessage();
}


?>