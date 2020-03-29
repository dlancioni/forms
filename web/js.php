<script language="JavaScript">

    // Navigate to page
    function go(tableId) {
        document.form1.method = 'post';
        document.form1.action = 'index.php?id_table='+ tableId; 
        document.form1.submit();
    }

    // Got to previous page
    function back() {
        history.go(-1);
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
            //alert("HTTP-Error: " + response.status);
        }
    }

</script>
