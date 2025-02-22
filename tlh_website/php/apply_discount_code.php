<?php 
session_start();

    if (isset($_GET["code"])){
        include("../php/connection.php");

        //read from database
        $code = $_GET["code"];
        $query = "select * from discount_codes where code = '$code'";
        $result = mysqli_query($con, $query);

        

        if($result && mysqli_num_rows($result) > 0){
            //code exists
            $code_data = mysqli_fetch_assoc($result);
            $_SESSION['discount_code'] = $code;
            $_SESSION['discount_amount'] = $code_data['discount'];
            header("location: ../html/discount_code.php");
        }else{
            //invalid code
            unset($_SESSION['discount_code']);
            $_SESSION['error'] = "Invalid Discount Code";
            header("location: ../html/discount_code.php");
        }
    }else{
        header("location: ../html/discount_code.php");
    }
?>