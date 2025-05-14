<?php
    
    $function_needle_haystack = '
    
        function stripos_array($haystack, $needles){
            foreach($needles as $needle) {
                if(($res = stripos($haystack, $needle)) !== false) {
                    return $res;
                }
            }
            return false;
        }
    
    ';
?>
