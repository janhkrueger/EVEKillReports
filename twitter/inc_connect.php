<?php
/**
 * inc_connect.php
 *
 */

$DB_HOST = "localhost";

// Ausgabe der BPOs
$DB_Name = "[DATABASE]";
$DB_USER = "[USERNAME]";
$DB_PASS = "[PASSWORD]";

$dbh = new PDO('mysql:host=localhost;dbname=[DATABASE]', '[USERNAME]', '[PASSWORD]');

?>
