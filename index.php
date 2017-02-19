<?php

if (!empty($_POST)) {
    $base64 = $_POST["img"];

    // save to file
    $myfile = fopen("images/encoded_crosswalk.txt", "wb") or die("Unable to open file!");
    fwrite($myfile, $base64);
    fclose($myfile);

    $result = exec("python process_img.py");
    echo json_encode(array("result"=>$result));
}

