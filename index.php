<?php

if (!empty($_POST)) {
    
    // vars
    $base64 = $_POST["img"];
    $tag = $_POST["tag"];

    // Write jpg
    $image = "data:image/png;base64, $base64";
    $image = imagecreatefrompng($image);
    imagejpeg($image, 'images/input.jpg', 100);
    imagedestroy($image);

    //router 
    $result = NULL;
    switch ($tag) {
        
        case "crosswalk":
            $result = exec("python3 answer.py walk images/input.jpg");
            break;
        case "face":
            $result = exec("python3 answer.py face images/input.jpg");
            break;
        
        default: break;
    }

    echo json_encode(array("result"=>$tag));

}

    // echo json_encode(array("result"=>"hey"));


