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
<<<<<<< HEAD
    // switch ($tag) {
    //
    //     case "crosswalk":
    //         $result = exec("python3 answer.py walk images/input.jpg");
    //         break;
    //
    //     case "face":
    //         $result = exec("python3 answer.py face images/input.jpg");
    //         break;
    //
    //     default: break;
    // }
    $result = exec("python3 answer.py walk images/input.jpg");
    echo json_encode(array("result"=>$result));

}
=======
    switch ($tag) {

        case "crosswalk":
            $result = exec('python3 hi_world.py');
#            $result = exec("ls")
#            $result = shell_exec("python /Users/alex/Documents/GitHub/StreetSmart/hello_world.py");
#            $result = exec("python answer.py walk images/input.jpg");
            break;

        case "face":
            $result = shell_exec('python answer.py face images/input.jpg');
            break;

        default: break;
    }

    echo json_encode(array($result));
>>>>>>> a6d95f93e3028e470bef9113a1dda4e80a59870e

}