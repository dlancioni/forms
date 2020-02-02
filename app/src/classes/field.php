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

            $sql = " select";
            
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
        function GetData($form) {

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

        /*
         * Turn field list into a SQL query
         */
        function PrepareStatementForQuery($form, $id) {

            // General Declaration
            $table_name = "";
            $sql = "select ";

            // Get the field list
            $resultset = $this->GetList($form);   

            // Prepare field list
            if ($resultset->num_rows > 0) {
                while ($row = $resultset->fetch_assoc()) {
                    $count ++;
                    $table_name = $row["table_name"];                    
                    $sql .= $row["name"] . " " . $row["label"];
                    if ($count < $resultset->num_rows) {
                        $sql .=  ", ";
                    }
                }
            }

            // Conditions
            $sql .= " from " . $table_name;            
            $sql .= " where " . $table_name . ".id_company = " . $this->getCompany();
            if ($id != null) {
                if ($id > 0) {
                    $sql .= " and " . $table_name . ".id = " . $id;
                }
            }
            $sql .= ";";

            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Insert
         */
        function PrepareStatementForInsert($table, $json) {

            // Get the field info
            $resultset = $this->GetList($table);
            $items = json_decode($json)->{'Fields'};

            // Prepare the field list
            $count ++;             
            if ($resultset->num_rows > 0) {
                while ($row = $resultset->fetch_assoc()) {
                    if ($row["name"] != "id") {                    
                        $count ++;                        
                        $table_name = $row["table_name"];
                        $field_name .= $row["name"];
                        foreach ($items as $item) {
                            if ($row["name"] == $item->Name) {

                                switch ($row["id_field_type"]) {
                                case 3: // Text
                                case 4: // Date
                                    $field_value .= "'" . $item->Value . "'";
                                    break;
                                default:
                                    $field_value .= $item->Value;                                    
                                }
                            }
                        }
                        if ($count < $resultset->num_rows) {
                            $field_name .=  ", ";
                            $field_value .=  ", ";
                        }                        
                    }
                }
            }

            // Create statement
            $sql = "";
            $sql .= "insert into " . $table_name . " (";
            $sql .= $field_name;
            $sql .= ") values (";
            $sql .= $field_value;            
            $sql .= ");";

            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Update
         */
        function PrepareStatementForUpdate($form, $data) {

            // General Declaration
            $table_name = "";
            $sql = "insert into tb_xyz (";

            // Get the field list
            $resultset = $this->GetList($form);

            // Prepare the field list
            if ($resultset->num_rows > 0) {
                while ($row = $resultset->fetch_assoc()) {
                    $count ++;
                    $table_name = $row["table_name"];                    
                    $sql .= $row["name"] . " " . $row["label"];
                    if ($count < $resultset->num_rows) {
                        $sql .=  ", ";
                    }
                }
            }
            
            // Field values
            $sql .= ") values (";
            // End of statement
            $sql .= ");";            
            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Delete
         */
        function PrepareStatementForDelete($form, $id) {

            // General Declaration
            $table_name = "";

            // Get the field list
            $resultset = $this->GetList($form);

            // Prepare the field list
            if ($resultset->num_rows > 0) {
                while ($row = $resultset->fetch_assoc()) {
                    $table_name = $row["table_name"];
                    break;
                }
            }
            
            // Field values
            $sql .= " delete from " . $table_name;
            $sql .= " where " . $table_name . ".id_company = " . $this->getCompany();
            $sql .= " and " . $table_name . ".id = " . $id . ";";          

            // Return record
            return $sql;
        }        


    } // End of class
?>