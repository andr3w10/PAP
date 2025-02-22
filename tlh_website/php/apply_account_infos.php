<?php
session_start();
include("connection.php");

    $username = $_POST['username'];
    $full_name = $_POST['full_name'];
    $email = $_POST['email'];
    $new_password = $_POST['n_password'];
    $rep_password = $_POST['r_password'];

    $curr_password = $_POST['curr_password'];

    $errors_msg = "";

    //check if password matches
    $old_user = $_SESSION['username'];
    $query = "select * from users where username = '$old_user' and password = '$curr_password' limit 1";
    $result = mysqli_query($con, $query);

    if($result)
    {
        if($result && mysqli_num_rows($result) > 0)
        {
            $is_correct = true;
        }
        else{
            $is_correct = false;
            $errors_msg .= "Password is incorrect!\n";
        }
    }

    $is_real = false;

    //if password matches
    if($is_correct){

        //change full name
        if($full_name != ""){
            $old_user = $_SESSION['username'];
            $query_full_name = "update users set name='$full_name' where username = '$old_user'";
            //save only on no errors
        }

        //change email
        if($email != ""){
            $query = "select * from users where email = '$email' limit 1";
            $result = mysqli_query($con, $query);

            if($result)
            {
                if($result && mysqli_num_rows($result) > 0)
                {
                    $can_change_email = false;
                    $errors_msg .= "Email already in use\n";
                }else{
                    $can_change_email = true;
                }
            }

            if($can_change_email){
                $old_user = $_SESSION['username'];
                $query_email = "update users set email='$email' where username = '$old_user'";
                //save only on no errors
            }
        }

        //change username
        if($username != ""){
            $query = "select * from users where username = '$username' limit 1";
            $result = mysqli_query($con, $query);

            if($result)
            {
                if($result && mysqli_num_rows($result) > 0)
                {
                    $can_change_username = false;
                    $errors_msg .= "Username already in use\n";
                }else{
                    $can_change_username = true;
                }
            }

            if($can_change_username){
                $old_user = $_SESSION['username'];
                $query_username = "update users set username='$username' where username = '$old_user'";
                //save only on no errors
            }
        }

        //change password
        if($new_password != "" || $rep_password != ""){
            if ($new_password != $rep_password){
                $errors_msg .= "New passwords don't match\n";
            }else{
                $old_user = $_SESSION['username'];
                $query_password = "update users set password='$new_password' where username = '$old_user'";
                //save only on no errors
            }
        }
    }


    $_SESSION['errors_text'] = $errors_msg;
    if($errors_msg != ""){
        //redirect to settings to see errors
        header("location: ../html/settings.php");
    }else{
        //redirect to other page because no errors
        if(isset($query_full_name)){
            $result = mysqli_query($con, $query_full_name);
        }
        
        if(isset($query_email)){
            $result = mysqli_query($con, $query_email);
        }

        if(isset($query_username)){
            $result = mysqli_query($con, $query_username);
            $_SESSION['username'] = $username;
        }

        if(isset($query_password)){
            $result = mysqli_query($con, $query_password);
        }


        $_SESSION['errors_text'] = "none";
        header("location: ../html/settings.php");
    }
?>