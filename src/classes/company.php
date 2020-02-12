<?php
    class Company extends Crud {

        public function Query($json) {

            $sql = "";
            $resultset = "";

            try {
                $sql = $this->PrepareStatementForQuery($json);
                $resultset = $this->getConnection()->query($sql);
            } catch (Exception $ex) {
                $this->set_error("Company.PrepareStatementForQuery()", $this->getConnection()->error);
            }

            return $resultset;
        }


    } // End of class
?>