<!-- Mandatory functions -->
<script language="JavaScript">

    // Mandatory on form load on report
    setValue('__id__', document.getElementById("selection").value);

    // Navigate to page
    function go(target, table, record, event) {

        // Set values
        setValue('__target__', target);
        setValue('__table__', table);
        setValue('__id__', record);
        setValue('__event__', event);

        // New asks to copy record    
        if (event == "1") {
            if (getId() > 0) {
                if (confirm("Would you like to use selected record as template?") == false) {
                    setValue('__id__', '0');
                }
            }
        }

        // Filter requires empty form
        if (event == "5") {
            setValue('__id__', '0');
        }

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php';
        document.form.submit();
    }

    // Navigate to page
    function page(pageOffset) {

        // Set values
        setValue('__offset__', pageOffset);
        setValue('__event__', "filter"); // filter results
        setValue('__target__', 1); // report

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php';
        document.form.submit();
    }

    // IDs to navigate
    // Target -> report or form
    // Table -> current transaction
    // Id -> the record we are changing or delte
    // Event -> New, Edit, Delete, Copy. Used to display buttons like Save, Delete or Filter
    function getTarget() {
        return document.getElementById('__target__').value;
    }
    function getTable() {
        return document.getElementById('__table__').value;
    }
    function getId() {
        return document.getElementById('__id__').value;
    }
    function getEvent() {
        return document.getElementById('__event__').value;
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
