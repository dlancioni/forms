
<?php
    class Dispatcher extends Crud {

        public function Query($json) {

            $sql = "";
            $resultset = "";

            try {
                $sql = $this->PrepareStatementForQuery($json);
                $resultset = $this->getConnection()->query($sql);
            } catch (Exception $ex) {
                $this->set_error("Company.Query()", $this->getConnection()->error);
            }
            return $resultset;
        }

        public function Insert($json) {

            $id = 0;
            $sql = "";
            $resultset = "";

            try {
                $sql = $this->PrepareStatementForInsert($json);
                $this->getConnection()->query($sql);
                $id = $this->getConnection()->insert_id;
                if ($id == 0) 
                    throw new Exception($this->getConnection()->error);
            } catch (Exception $ex) {
                $this->set_error("Company.Insert()", $this->getConnection()->error);
            }
            return $id;
        }        

    } // End of class
?>