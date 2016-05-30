<?php

// require codebird
require_once('codebird.php');
require "inc_connect.php";

$sql = "select count(KR_participants.killID) AS anzahl
from KR_participants 
where ((KR_participants.shipTypeID = 33328) and (KR_participants.isVictim = 1)) 
AND cast(KR_participants.kill_time as date) = cast(now() as date) - interval 1 day";

$sth = $dbh->prepare($sql);
$sth->execute();

$anzahl = $sth->fetch(PDO::FETCH_ASSOC);
$anzahl =  $anzahl['anzahl'];

\Codebird\Codebird::setConsumerKey("", "");
$cb = \Codebird\Codebird::getInstance();
$cb->setToken("", "");

$params = array(
  'status' => $anzahl.' #kills of golden eggs yesterday. #tweetfleet #evedata'
);
$reply = $cb->statuses_update($params);

?>
