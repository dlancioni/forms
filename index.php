<!DOCTYPE html>
<html>
<body>
<?php
echo var_dump($_REQUEST);
?>

<form id='form1' name='form1'>
    <input name="__table__" type="text" value="0">
    <input name="__target__" type="text" value="1">
    <input name="__id__" type="text" value="1">
    <input name="__event__" type="text" value="0">
    <input name="__offset__" type="text" value="0">
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