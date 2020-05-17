<!-- Mandatory functions -->
<script language="JavaScript">

    // Mandatory on form load on report
//    setValue('__id__', document.getElementById("selection").value);
    
    // Navigate to page
    function go(page, table, event, id) {

        // New asks to copy record    
        if (event == "1") {
            if (getId() > 0) {
                if (confirm("Would you like to use selected record as template?") == false) {
                    id = 0;
                }
            }
        }

        // Filter requires empty form
        if (event == "5") {
            id = 0;
        }

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php?id_page=' + page + '&id_table=' + table + '&id_event=' + event + '&id=' + id;
        document.form.submit();
    }

    // Navigate to page
    function page(pageOffset) {

        // Set values
        //setValue('__offset__', pageOffset);
        //setValue('__event__', "filter"); // filter results
        //setValue('__target__', 1); // report

        // Submit data
        document.form.method = 'post';
        document.form.action = 'index.php';
        document.form.submit();
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
