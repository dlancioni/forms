<!-- Mandatory functions -->
<script language="JavaScript">

    // Mandatory on form load on report
    //setValue('id', document.getElementById("selection").value);
    
    // Navigate to page
    function go(page, table, event, id) {

        // Set selection
        setValue('id_page', page);
        setValue('id_table', table);
        setValue('id_event', event);
        setValue('id', id);

        // New asks to copy record    
        if (event == 1) {
            if (getId() > 0) {
                if (confirm("Would you like to use selected record as template?") == false) {
                    setValue('id', 0);
                }
            }
        }

        // Filter requires empty form
        if (event == 5) {
            id = 0;
        }

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php';
        document.form.submit();
    }

    // Navigate to page
    function page(pageOffset) {

        // Set values
        setValue('id_page', 1);
        setValue('id_event', 5);
        setValue('page_offset', pageOffset);

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php';
        document.form.submit();
    }

    // Used to set information above
    function getValue(field) {
        return document.getElementById(field).value;
    }
    function setValue(field, value) {
        document.getElementById(field).value = value;
    }

    // Navigation related functions
    function getPage() {
        if (getValue('id_page') == 1) {
            return 2;
        } else {
            return 1;
        }
    }
    function getTable() {
        return getValue('id_table');
    }
    function getEvent() {
        return getValue('id_event');
    }
    function getId() {
        return getValue('id');
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
