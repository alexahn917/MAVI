<?php

if (!empty($_POST)) {
    // vars
    $base64 = $_POST["img"];
    $tag = $_POST["tag"];

    // Write jpg
    $base64 = base64_decode($base64);
    $source = imagecreatefromstring($base64);
    $imageSave = imagejpeg($source,"images/input.jpg",100);
    imagedestroy($source);



}
