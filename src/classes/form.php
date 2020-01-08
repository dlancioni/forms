<?php    

    /*
     * Developed by David Lancioni - 01/2020
     * Create methods used to manipulate transactions
     */    
    class Form extends Base {

        /*
         * GetList
         */
        function GetList() {

            // Query form name            
            $sql = "";
            $sql .= " select * from tb_form "; 
            $sql .= " where id_company = " . $this->getCompany();
            $result = $this->getConnection()->query($sql);

            // Return record
            return $result;
        }

        /*
         * Get form name
         */
        function getName() {

            // General Declaration
            $sql = "";
            $name = "";

            // Query form name            
            $sql .= " select * from tb_form "; 
            $sql .= " where id_company = " . $this->getCompany();
            $result = $this->getConnection()->query($sql);

            // Keep ther ecord
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $name = $row["name"];
                }
            }

            // Return record
            return $name;
        }
    } // End of class
?>