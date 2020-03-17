
<?php
    class Dispatcher extends Base {

        public function Execute($json) {

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

    } // End of class
?>