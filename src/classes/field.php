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
            $sql .= " tb_field.id,"                                         . PHP_EOL;
            $sql .= " tb_field.id_company,"                                 . PHP_EOL;
            $sql .= " tb_field.id_form,"                                    . PHP_EOL;
            $sql .= " tb_field.name,"                                       . PHP_EOL;
            $sql .= " tb_field.label,"                                      . PHP_EOL;
            $sql .= " tb_field.id_field_type,"                              . PHP_EOL;
            $sql .= " tb_field_type.name_field_type,"                       . PHP_EOL;
            $sql .= " tb_field.size,"                                       . PHP_EOL;
            $sql .= " tb_field.mask,"                                       . PHP_EOL;
            $sql .= " tb_field.is_pk,"                                      . PHP_EOL;
            $sql .= " tb_field.id_fk,"                                      . PHP_EOL;
            $sql .= " tb_field.is_nullable,"                                . PHP_EOL;
            $sql .= " tb_field.is_unique"                                   . PHP_EOL;            
            $sql .= " tb_form.table_name,"                                  . PHP_EOL . PHP_EOL;
           
            // From
            $sql .= " from tb_field"                                        . PHP_EOL . PHP_EOL;
            
            // Join tb_form
            $sql .= " inner join tb_form on"                                . PHP_EOL;
            $sql .= " tb_field.id_company = tb_form.id_company and"         . PHP_EOL;
            $sql .= " tb_field.id_form = tb_form.id"                        . PHP_EOL . PHP_EOL;
            
            // Join tb_field_type
            $sql .= " inner join tb_field_type on"                          . PHP_EOL;
            $sql .= " tb_field.id_field_type = tb_field_type.id"            . PHP_EOL . PHP_EOL;
            
            // Condition
            $sql .= " where tb_field.id_company = " . $this->getCompany()   . PHP_EOL . PHP_EOL;

            if ($form != 0) {
                $sql .= " and tb_field.id_form = " . $form                  . PHP_EOL;
            }

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
            $sql = "select" . PHP_EOL;

            // Get the field list
            $resultset = $this->GetList($form);   

            if ($resultset->num_rows > 0) {
                
                // Append field list
                while ($row = $result->fetch_assoc()) {
                    $sql .= $row["name"] . "," . PHP_EOL;
                }

                // Append from
                $sql .= " from "  . $row["table_name"];
            }    

            // Return record
            return $sql;
        }
    } // End of class
?>