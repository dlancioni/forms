<?php 

    class Transaction {
        
        private $connection;
        private $company;

        function __construct($conn, $cid) {
            $this->connection = $conn;
            $this->company = $cid;
        }
    
        function getCompany() {
            return $this->company;
        }
    }
?>