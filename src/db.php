
<?php
    class Db {

        private $error;
        function __construct() {
        }

        // Error handling    
        function set_error($source, $error) {
            if ($error != "")
            $this->error = $source . ": " . $error;
        }
        function get_error() {
            return $this->error;
        }        

        public function getConnection() {
            try {
                $connection = pg_connect("postgres://qqbzxiqr:EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9@tuffi.db.elephantsql.com:5432/qqbzxiqr");
                $error = pg_last_error($connection);
                if ($error != "") {
                    die("Connection failed: " . $error);
                }
            } catch (Exception $ex) {
                $this->set_error("Db.getConnection()", $this->getConnection()->error);
            }
            return $connection;
        }

        public function Execute($sql, $json) {

            $data = "";

            try {
                $connection = $this->getConnection();
                $resultset = pg_query_params($connection, $sql, array($json));
                while ($row = pg_fetch_row($resultset)) {
                    if ($row[0]) {
                        $data = json_decode($row[0]);
                    }
                }
                $this->set_error("", "");
            } catch (exception $e) {
                $data = "";
                $this->set_error("DB.Execute()", pg_last_error($connection));
            } finally {
                pg_close($connection);
            }
            return $data;
        }

        public function Query($sql) {
            try {
                $connection = $this->getConnection();
                $resultset = pg_query($connection, $sql);
                $this->set_error("", "");
            } catch (exception $ex) {
                $resultset = "";
                $this->set_error("db.Query()", pg_last_error($connection));
            } finally {
                pg_close($connection);
            }
            return $resultset;
        }

    } // End of class
?>