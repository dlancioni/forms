<?php    

    /*
     * Base class
     */
    include "base.php";

    class Transaction extends Base {

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
                while($row = $result->fetch_assoc()) {
                    $name = $row["name"];
                }
            }

            // Return record
            return $name;
        }

    } // End of class
?>