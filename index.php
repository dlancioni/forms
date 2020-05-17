<?php
    // Start session
    session_start();

    // Include dependencies    
    include "src/util.php";

    $system = 1;
    $language = 2; // Portuguese
    $user = 1;
    $table = 1;
    $action = 0;
    $jsonUtil = new JsonUtil();
    $json = $jsonUtil->getJson($system, $language, $user, $table, $action);
    $_SESSION['SESSION'] = $json;
?>

<!DOCTYPE html>
<html>
<body>

<form id='form1' name='form1'>
    <input id="login" type="button" value="Login" onClick="go();">
</form>

<script language="JavaScript">
    function go() {
        document.form1.method = 'post';
        document.form1.action = 'web/index.php';
        document.form1.submit();
    }
</script>

</body>
</html>