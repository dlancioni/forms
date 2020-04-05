<!DOCTYPE html>
<html>
<body>
<?php
echo var_dump($_REQUEST);
?>

<form id='form1' name='form1'>
    <input name="page_offset" type="text" value="0">
    <input name="id_table" type="text" value="1">
    <input name="id_target" type="text" value="1">
    <input name="id_record" type="text" value="0">
    <input name="id_event" type="text" value="0">
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