<?php
    $die_check = '
        // ldap_close($ldapconn);
        if($die) {
            if($debug){echo "DEBUG: Authproc reached end without error. Exiting. Login will not continue.<hr>";};
            echo "<script>alert(\"DEBUG:\\\n\\\nAuthproc reached end without error. Exiting.\\\nLogin will not continue.\");</script>";
            die();
        };
    ';
?>
