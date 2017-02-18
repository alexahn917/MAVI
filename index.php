<?php


$img = array();
if (!empty($_POST)) {
    $base64 = $_POST["img"];

    $arr = array('base64' => $base64);
    echo json_encode($arr);

}
