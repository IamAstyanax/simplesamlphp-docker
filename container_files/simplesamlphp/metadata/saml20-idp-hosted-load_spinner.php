<?php
$load_spinner = '

    if(!$debug) {
        echo "<style>";
        echo "#loader {";
        echo   "position: absolute;";
        echo   "left: 50%;";
        echo   "top: 50%;";
        echo   "transform: translate(-50%, -50%);";
        echo   "z-index: 1;";
        echo   "width: 80px;";
        echo   "height: 80px;";
        echo   "background-image: url(\'/var/simplesamlphp/public/assets/base/images/picking-up-newspaper-odie.gif\');";
        echo   "background-size: contain;";
        echo   "background-repeat: no-repeat;";
        echo "}";
        echo "</style>";

        echo "<div id=\"loader\"></div>";
    }

';
?>