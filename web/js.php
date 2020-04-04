<script language="JavaScript">

    // Navigate to page
    function go(targetId, tableId, recordId) {

        // Set values
        setValue('id_target', targetId);
        setValue('id_table', tableId);
        setValue('id_record', recordId);

        // Submit data
        document.form1.method = 'post';
        document.form1.action = 'index.php';
        document.form1.submit();
    }

    // IDs to navigate
    function getTarget() {
        return document.getElementById('id_target').value;
    }
    function getTable() {
        return document.getElementById('id_table').value;
    }
    function getId() {
        return document.getElementById('id_record').value;
    }

    function setValue(field, value) {
        return document.getElementById(field).value = value;
    }    

    // Execute URL and return data
    async function execute() {
    
        var data = new URLSearchParams();
        for (const pair of new FormData(form1)) {
            data.append(pair[0], pair[1]);
        }

        // Ajax call    
        let response = await fetch('../src/execute.php', {method: 'post', body: data})
        if (response.ok) {
            let json = await response.text();
            alert(json);
        } else {
            alert("HTTP-Error: " + response.status);
        }
    }

</script>
