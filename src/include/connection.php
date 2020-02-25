<?php
    // Not used, for reference only
    $servername = "	tuffi.db.elephantsql.com";
    $username = "qqbzxiqr";
    $password = "EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9";
    $dbname = "qqbzxiqr";;

    // Create connection
    $conn = pg_connect("postgres://qqbzxiqr:EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9@tuffi.db.elephantsql.com:5432/qqbzxiqr");
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
