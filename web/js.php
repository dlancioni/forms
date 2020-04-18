<!-- Mandatory functions -->
<script language="JavaScript">

    // Mandatory on form load
    setValue('id_record', document.getElementById("selection").value);

    // Navigate to page
    function go(targetId, tableId, recordId, eventId) {

        // Set values
        setValue('id_target', targetId);
        setValue('id_table', tableId);
        setValue('id_record', recordId);
        setValue('id_event', eventId);

        // New asks to copy record    
        if (eventId == 1) {
            if (getId() > 0) {
                if (confirm("Would you like to use selected record as template?") == false) {
                    setValue('id_record', '0');
                }
            }
        }

        // Filter requires empty form
        if (eventId == 5) {
            setValue('id_record', '0');
        }

        // Submit data
        document.form1.method = 'post';
        document.form1.action = 'index.php';
        document.form1.submit();
    }

    // IDs to navigate
    // Target -> report or form
    // Table -> current transaction
    // Id -> the record we are changing or delte
    // Event -> New, Edit, Delete, Copy. Used to display buttons like Save, Delete or Filter
    function getTarget() {
        return document.getElementById('id_target').value;
    }
    function getTable() {
        return document.getElementById('id_table').value;
    }
    function getId() {
        return document.getElementById('id_record').value;
    }
    function getEvent() {
        return document.getElementById('id_event').value;
    }    

    // Used to set information above
    function setValue(field, value) {
        document.getElementById(field).value = value;
    }    

    // Execute URL and return data
    async function execute() {

        // Read fields in the form
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
