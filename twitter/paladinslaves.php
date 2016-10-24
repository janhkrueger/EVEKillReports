<?php

// require codebird
require_once('codebird.php');
require "inc_connectpsql.php";

$sql = "SELECT s.averagePrice as Slaves, p.averagePrice as Paladin, ROUND((p.averagePrice / s.averagePrice)+0.5) AS slavescount  FROM universe.crestMarketPrices s, universe.crestMarketPrices p  WHERE s.typeID = 3721 AND p.typeID = 28659 ORDER BY s.surveyDate desc, p.surveyDate desc LIMIT 1 OFFSET 0;";

$sth = $dbh->prepare($sql);
$sth->execute();

$anzahl = $sth->fetch(PDO::FETCH_ASSOC);
$anzahl =  $anzahl['slavescount'];

print $anzahl;

\Codebird\Codebird::setConsumerKey("", "");
$cb = \Codebird\Codebird::getInstance();
$cb->setToken("", "");

$params = array(
  'status' => 'Today I need '.$anzahl.' slaves to buy me a new and shiny paladin. #tweetfleet #evedata'
);
$reply = $cb->statuses_update($params);

?>