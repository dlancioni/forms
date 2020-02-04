<?php    
    class Base {

        private $connection;
        private $company;

        function __construct($connection, $company) {
            $this->connection = $connection;
            $this->company = $company;
        }

        function getCompany() {
            return $this->company;
        }

        function getConnection() {
            return $this->connection;
        }
    }
?>