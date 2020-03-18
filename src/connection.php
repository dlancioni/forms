<?php
    // Not used, for reference only
    $error = "";
    $servername = "	tuffi.db.elephantsql.com";
    $username = "qqbzxiqr";
    $password = "EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9";
    $dbname = "qqbzxiqr";;

    // Create connection
    $conn = pg_connect("postgres://qqbzxiqr:EmiJvVhFJGxDEKJoV6yK9A6o2G5pkmR9@tuffi.db.elephantsql.com:5432/qqbzxiqr");
    $error = pg_last_error($conn);

    if ($error != "") {
        die("Connection failed: " . $error);
    }
?>
