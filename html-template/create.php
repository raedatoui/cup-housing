<?php

$method = $_GET['method'];
$name = $_GET['name'];

$postData = file_get_contents('php://input');

if ($postData) {

  // get bytearray

  // add headers for download dialog-box
  header('Content-Type: application/pdf');
  header('Content-Length: '.strlen($postData));
  header('Content-disposition:'.$method.'; filename="'.$name.'"');
  echo $postData;

}  else echo 'An error occured.';

?>
