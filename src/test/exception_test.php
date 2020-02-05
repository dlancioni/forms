<?php include "../include/connection.php";?>
<?php include "../classes/base.php";?>
<?php include "../classes/crud.php";?>
<?php include "../classes/system.php";?>

<?php
    
    try{
        //division by zero
        $error = 'Always throw this error';
        throw new Exception($error);
    }
    catch(Exception $ex){
        echo 'Got it!';
    }    


?>