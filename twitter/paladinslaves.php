<?php

// require codebird
require_once('codebird.php');
require "inc_connect.php";

$sql = "SELECT s.averagePrice as Slaves, p.averagePrice as Paladin, ROUND((p.averagePrice / s.averagePrice)+0.5) AS slavescount
 FROM crestMarketPrices s, crestMarketPrices p
 WHERE s.typeID = 3721
 AND p.typeID = 28659
 ORDER BY s.surveyDate desc, p.surveyDate desc LIMIT 1;"

$sth = $dbh->prepare($sql);
$sth->execute();

$anzahl = $sth->fetch(PDO::FETCH_ASSOC);
$anzahl =  $anzahl['slavecount'];

\Codebird\Codebird::setConsumerKey("", "");
$cb = \Codebird\Codebird::getInstance();
$cb->setToken("", "");

# unfinished
$params = array(
  'status' => $anzahl.' #kills of golden eggs yesterday. #tweetfleet #evedata'
);
# $reply = $cb->statuses_update($params);

?>
