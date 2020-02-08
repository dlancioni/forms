<?php    
    class Base {

        private $connection;
        private $company;
        private $error;
        private $table;

        function __construct($connection, $company) {
            //$this->set_error("");
            $this->connection = $connection;
            $this->company = $company;
        }

        // Error handling    
        function set_error($source, $error) {
            if ($error != "")
            $this->error = $source . ": " . $error;
        }
        function get_error() {
            return $this->error;
        }

        // Key handling
        function getCompany() {
            return $this->company;
        }

        // Connection handling
        function getConnection() {
            return $this->connection;
        }

        // Current table
        function set_table($table) {
            $this->table = $table;
        }
        function get_table() {
            return $this->table;
        }

    }
?>