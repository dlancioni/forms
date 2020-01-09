<?php    

    /*
     * Developed by David Lancioni - 01/2020
     * Create methods used to manipulate fields
     */    
    class Field extends Base {
        /*
         * Get fields for given transaction
         */
        function GetList($form) {

            $sql = " select" . PHP_EOL;
            
            // Field list
            $sql .= " tb_field.id,";
            $sql .= " tb_field.id_company,";
            $sql .= " tb_field.id_form,";
            $sql .= " tb_field.name,";
            $sql .= " tb_field.label,";
            $sql .= " tb_field.id_field_type,";
            $sql .= " tb_field_type.name field_type,";
            $sql .= " tb_field.size,";
            $sql .= " tb_field.mask,";
            $sql .= " tb_field.is_pk,";
            $sql .= " tb_field.id_fk,";
            $sql .= " tb_field.is_nullable,";
            $sql .= " tb_field.is_unique,";
            $sql .= " tb_form.table_name";
           
            // From
            $sql .= " from tb_field";
            
            // Join tb_form
            $sql .= " inner join tb_form on";
            $sql .= " tb_field.id_company = tb_form.id_company and";
            $sql .= " tb_field.id_form = tb_form.id";
            
            // Join tb_field_type
            $sql .= " inner join tb_field_type on";
            $sql .= " tb_field.id_field_type = tb_field_type.id";
            
            // Condition
            $sql .= " where tb_field.id_company = " . $this->getCompany();

            if ($form != 0) {
                $sql .= " and tb_field.id_form = " . $form;
            }

            // Ordering    
            $sql .= " order by tb_field.id;";

            // Execute query
            $resultset = $this->getConnection()->query($sql);

            // Return record
            return $resultset;
        }

        /*
         * Turn field list into a SQL query
         */
        function PrepareStatementToQuery($form) {

            // General Declaration
            $table_name = "";
            $sql = "select ";

            // Get the field list
            $resultset = $this->GetList($form);   

            // Prepare query statement
            if ($resultset->num_rows > 0) {

                // Prepare field list
                while ($row = $resultset->fetch_assoc()) {
                    $count ++;
                    $sql .= $row["name"] . " " . $row["label"];
                    if ($count < $resultset->num_rows) {
                        $sql .=  ", ";
                    }
                    $table_name = $row["table_name"];                    
                }

                // Append from
                $sql .= " from " . $table_name;
            }    

            // Execute query
            $resultset = $this->getConnection()->query($sql);

            // Return record
            return $resultset;
        }

    } // End of class
?>