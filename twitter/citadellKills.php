<?php

// require codebird
require_once('codebird.php');

\Codebird\Codebird::setConsumerKey("", "");
$cb = \Codebird\Codebird::getInstance();
$cb->setToken("", "");

$params = array(
  'status' => '#citadel kills this year. #tweetfleet #evedata',
  'media[]' => '/var/games/KillReporter/EVEData/charts/Citadels_2016.png'
);
$reply = $cb->statuses_updateWithMedia($params);

?>