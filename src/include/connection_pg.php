<?php
//$connStr = "host=localhost port=5432 dbname=postgres user=postgres options='--application_name=$appName'";
$connStr = "postgres://qqbzxiqr:EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9@tuffi.db.elephantsql.com:5432/qqbzxiqr";

//simple check
$conn = pg_connect($connStr);
//$result = pg_query($conn, "select * from pg_stat_activity");
//var_dump(pg_fetch_all($result));
?>
