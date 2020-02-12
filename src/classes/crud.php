<?php    

    /*
     * Developed by David Lancioni - 01/2020
     * Create methods used to manipulate fields
     */    
    class Crud extends Base {
        /*
         * Get fields for given transaction
         */
        private function GetList($form) {

            $resultset = null;
            $sql = " select";

            try {

                // Field list
                $sql .= " tb_field.id,";
                $sql .= " tb_field.id_company,";
                $sql .= " tb_field.id_system,";
                $sql .= " tb_field.id_table,";
                $sql .= " tb_field.label,";
                $sql .= " tb_field.name,";
                $sql .= " tb_field.id_type,";
                $sql .= " tb_field_type.name field_type,";
                $sql .= " tb_field.size,";
                $sql .= " tb_field.mask,";
                $sql .= " tb_field.id_fk,";
                $sql .= " tb_field.mandatory,";
                $sql .= " tb_field.unique,";
                $sql .= " tb_table.table_name";
            
                // From
                $sql .= " from tb_field";
                
                // Join tb_form
                $sql .= " inner join tb_table on";
                $sql .= " tb_field.id_company = tb_table.id_company and";
                $sql .= " tb_field.id_system = tb_table.id_system and";            
                $sql .= " tb_field.id_table = tb_table.id";
                
                // Join tb_field_type
                $sql .= " inner join tb_field_type on";
                $sql .= " tb_field.id_type = tb_field_type.id";
                
                // Condition
                $sql .= " where tb_field.id_company = " . $this->getCompany();
                $sql .= " and tb_field.id_system = " . $this->getCompany();

                if ($form != 0) {
                    $sql .= " and tb_field.id_table = " . $form;
                }

                // Ordering    
                $sql .= " order by tb_field.id;";

                // Execute query
                $resultset = $this->getConnection()->query($sql);

                // Error handling
                $this->set_error("Crud.GetList()", $this->getConnection()->error);

                // Keep current table in memory
                if ($this->get_error() == "") {
                    if ($resultset->num_rows > 0) {
                        $this->set_table($resultset);
                    }
                }

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }

            // Return record
            return $resultset;
        }

        /*
         * Turn field list into a SQL query
         */
        private function GetData($id_table) {

            // General Declaration
            $resultset = null;
            $table_name = "";
            $sql = "select ";

            try {

                // Get the field list
                $resultset = $this->GetList($id_table);

                // Prepare query statement
                if ($resultset->num_rows > 0) {

                    // Prepare field list
                    while ($row = $resultset->fetch_assoc()) {
                        $count ++;
                        $sql .= $row["name"] . " " . "'" . $row["label"] . "'";
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

                // Error handling            
                $this->set_error("Crud.GetData()", $this->getConnection()->error);

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }            

            // Return record
            return $resultset;
        }

        /*
         * Turn field list into a SQL query
         */
        public function PrepareStatementForQuery($id_table, $id) {

            // General Declaration
            $count = 0;
            $sql = "";
            $table_name = "";
            
            try {

                // Get the field list
                $resultset = $this->GetList($id_table);

                // Prepare field list
                if ($resultset != null) {
                    $sql = "select ";                
                    if ($resultset->num_rows > 0) {
                        while ($row = $resultset->fetch_assoc()) {
                            $count ++;
                            $table_name = $row["table_name"];                    
                            $sql .= $row["name"] . " " . "'" . $row["label"] . "'";
                            if ($count < $resultset->num_rows) {
                                $sql .=  ", ";
                            }
                        }
                    }
                    // Conditions
                    $sql .= " from " . $table_name;  
                    if ($this->get_error() == "tb_company") {
                        $sql .= " where " . $table_name . ".id_company = " . $this->getCompany();
                        $sql .= " and " . $table_name . ".id_system = " . $this->getCompany();
                        if ($id != null) {
                            if ($id > 0) {
                                $sql .= " and " . $table_name . ".id = " . $id;
                            }
                        }
                        $sql .= ";";                    
                    } else {
                        if ($id != null) {
                            if ($id > 0) {
                                $sql .= " where id = " . $id;
                            }
                        }                    
                    }
                }

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }            

            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Insert
         */
        public function PrepareStatementForInsert($table, $json) {

            // General declaration
            $count = 0;
            $sql = "";            
            $field_name = "";
            $field_value = "";
            $tag = "";

            try {

                // Get the field list    
                $resultset = $this->GetList($table);                

                // Prepare the field list      
                if ($resultset != null) {  
                    if ($resultset->num_rows > 0) {
                        $obj = json_decode($json);
                        while ($row = $resultset->fetch_assoc()) {
                            $count ++;                        
                            $table_name = $row["table_name"];
                            $field_name .= $row["name"];
                            $tag = $row["name"];

                            switch ($row["id_type"]) {
                                case 3: // Text
                                case 4: // Date
                                    $field_value .= "'" . $obj->Fields->$tag . "'";
                                    break;
                                default:
                                    $field_value .= $obj->Fields->$tag;
                            }

                            if ($count < $resultset->num_rows) {
                                $field_name .=  ", ";
                                $field_value .=  ", ";
                            }
                        }
                    }

                    // Create statement
                    $sql .= "insert into " . $table_name . " (";
                    $sql .= $field_name;
                    $sql .= ") values (";
                    $sql .= $field_value;            
                    $sql .= ");";
                }

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }

            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Update
         */
        public function PrepareStatementForUpdate($table, $json) {

            // General declaration
            $id = 0;
            $count = 0;
            $sql = "";
            $field_list = "";
            $field_value = "";

            try {

                // Get the field list
                $resultset = $this->GetList($table);

                // Prepare the field list
                if ($resultset != null) {            
                    if ($resultset->num_rows > 0) {
                        $obj = json_decode($json);
                        while ($row = $resultset->fetch_assoc()) {
                            
                            $count ++;
                            $table_name = $row["table_name"];
                            $field_name = $row["name"];
                            $tag = $row["name"];                            

                            switch ($row["id_type"]) {
                                case 3: // Text
                                case 4: // Date
                                    $field_value = "'" . $obj->Fields->$tag . "'";
                                    break;
                                default:
                                    $field_value = $obj->Fields->$tag;
                            }

                            $field_list .= $field_name . " = " . $field_value;
                            if ($count < $resultset->num_rows) {
                                $field_list .=  ", ";
                            }
                        }
                    }

                    $id = $obj->Fields->id;

                    // Create statement
                    $sql .= "update " . $table_name . " set ";
                    $sql .= $field_list;
                    $sql .= " where id_company = " . $this->getCompany();
                    $sql .= " and id_system = " . $this->getCompany();
                    $sql .= " and id = " . $id;
                }

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }
            // Return record
            return $sql;
        }

        /*
         * Turn field list into a SQL Delete
         */
        public function PrepareStatementForDelete($table, $id) {

            // General Declaration      
            $sql = "";
            $table_name = "";

            try {

                // Get the field list
                $resultset = $this->GetList($table);

                // Prepare the field list
                if ($resultset != null) {
                    if ($resultset->num_rows > 0) {
                        while ($row = $resultset->fetch_assoc()) {
                            $table_name = $row["table_name"];
                            break;
                        }
                    }

                    // Field values
                    $sql .= " delete from " . $table_name;
                    $sql .= " where id_company = " . $this->getCompany();
                    $sql .= " and id_system = " . $this->getCompany();
                    $sql .= " and id = " . $id . ";";          
                }

            } catch (Exception $ex) {
                $this->set_error("Crud.GetList()", $ex->getMessage());
            }            

            // Return record
            return $sql;
        }        

    } // End of class
?>