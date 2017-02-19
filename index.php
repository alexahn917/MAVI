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

    // router
    $result = NULL;
    switch ($tag) {

        case "crosswalk":
            $result = exec("python answer.py walk images/input.jpg");
            break;

        case "face":
            $result = exec("python answer.py face images/input.jpg");
            break;

        default: break;
    }

     echo json_encode(array("result"=>$result));
}
