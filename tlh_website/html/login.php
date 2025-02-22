<?php 
session_start();

    $login_error = false;
    $login_message = "";
    $signup_error = false;
    $signup_message = "";

	include("../php/connection.php");
	include("../php/functions.php");

//SIGN IN
    if(isset($_POST['target'])){
        if($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['target'] == "signin")
        {
            //something was posted
            $username = $_POST['username'];
            $password = $_POST['password'];
    
            if(!empty($username) && !empty($password))
            {
    
                //read from database
                $query = "select * from users where username = '$username' limit 1";
                $result = mysqli_query($con, $query);
    
                if($result)
                {
                    if($result && mysqli_num_rows($result) > 0)
                    {
    
                        $user_data = mysqli_fetch_assoc($result);
                        
                        //die($password . " ---- " . $user_data['password']);
                        if(password_verify($password, $user_data['password']))
                        {
                            $_SESSION['username'] = $user_data['username'];
                            $login_error = false;
                            $login_message = "";
                            if(isset($_GET['to'])){
                                header("Location: ".$_GET['to'].".php");
                            }else{
                                header("Location: index.php");
                            }
                            die;
                        }
                    }
                }
                
                $login_error = true;
                $login_message = "Sorry the credentials you are using are invalid.";
            }else{
                $login_error = true;
                $login_message = "Sorry the credentials you are using are invalid.";
            }
        }
    }else{
        // echo "ERROR SETTING TARGET (IN UP)";
    }


//SIGN UP

	if($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['target'] == "signup")
	{
        $can_create_user = true;
        $can_create_email = true;

		//something was posted
		$name = $_POST['name'];
		$username = $_POST['username'];
        $email = $_POST['email'];
		$password = password_hash(trim($_POST['password']), PASSWORD_DEFAULT);

        $query = "select * from users where username = '$username' limit 1";
        $result = mysqli_query($con, $query);

        if($result)
        {
            if($result && mysqli_num_rows($result) > 0)
            {
                $can_create_user = false;
            }
        }

        $query = "select * from users where email = '$email' limit 1";
        $result = mysqli_query($con, $query);

        if($result)
        {
            if($result && mysqli_num_rows($result) > 0)
            {
                $can_create_email = false;
            }
        }

		if(!empty($name) && !empty($username) && !empty($email) && !empty($password) && $can_create_user && $can_create_email)
		{

			//save to database
			$query = "insert into users (name,username,email,password) values ('$name','$username','$email','$password')";

			$result = mysqli_query($con, $query);

            if(!$result){
                echo("Error description: " . mysqli_error($con));
                die;
            }
            $signup_error = false;
            $signup_message = "";
			header("Location: ../html/login.php");
			die;
		}else
		{
			$signup_error = true;
            if (empty($name)){
                $signup_message = "Insert a name please.";
            }elseif (empty($username)){
                $signup_message = "Invalid username.";
            }elseif (!$can_create_user){
                $signup_message = "Username in use.";
            }elseif (!$can_create_email){
                    $signup_message = "Email in use.";
            }elseif (empty($email)){
                $signup_message = "Insert a valid email.";
            }elseif (empty($password)){
                $signup_message = "Insert a valid password.";
            }else{
                $signup_message = "Error creating account. Try again later.";
            }
		}
	}
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- ===== PAGEICON ===== -->
        <link rel="shortcut icon" href="../assets/img/page/head.png" type="image/x-icon">

        <!-- ===== CSS ===== -->
        <link rel="stylesheet" href="../assets/css/login_styles.css?v=<?php echo time(); ?>">
    
        <!-- ===== BOX ICONS ===== -->
        <link href='https://cdn.jsdelivr.net/npm/boxicons@2.0.5/css/boxicons.min.css' rel='stylesheet'>

        <title>The Lost Hero</title>
    



        <?php include("preloader.php"); ?>




        <header class="header" id="header">
            <div class="head container">
                <a href="index.php" class="header_logo">
                    <img src="../assets/img/page/logo.png" class="header_logo-img"></img>
                </a>
                <!--<h4 class="header_logo-txt">&#169; Andr3w. All rigths reserved</h4>-->
            </div>
        </header>

        <div class="login">
            <div class="login_content">
                <div class="login_img">
                    <img src="../assets/img/login/signin.png" alt="">
                </div>

                <div class="login_forms">
                    <!-- LOGIN -->
                    <form method="post" class="login_register <?php if($signup_error){echo "none";}else{echo "block";} ?>" id="login-in">
                        <h1 class="login_title">Sign In</h1>

                        <div class="warnings_box">
                            <h4 class="warnings_text"><?php if($login_error){echo $login_message;} ?></h4>
                        </div>
    
                        <div class="login_box">
                            <i class='bx bx-user login_icon'></i>
                            <input type="text" placeholder="Username" class="login_input" name="username">
                        </div>

                        
                        <div class="input">
                            <div class="input__overlay" id="input-overlay-in"></div>

                            <i class='bx bx-lock-alt input__lock'></i>
                            <input type="password" placeholder="Password" class="input__password" id="input-pass-in" name="password">
                            <i class='bx bx-hide input__icon' id="input-icon-in"></i>
                        </div>


                        <a href="#" class="login_forgot">Forgot password?</a>

                        <input type="hidden" name="target" value="signin">
                        <a onclick="this.parentElement.submit()" href="#" class="login_button">Sign In</a>

                        <div>
                            <span class="login_account">Don't have an Account ?</span>
                            <span class="login_signin" id="sign-up">Sign Up</span>
                        </div>

                        <div class="login_social">
                            
                        </div>
                    </form>

                    <!-- SIGNUP -->
                    <form method="post" class="login_create <?php if($signup_error){echo "block";}else{echo "none";} ?>" id="login-up">
                        <h1 class="login_title">Create Account</h1>

                        <div class="warnings_box">
                            <h4 class="warnings_text"><?php if($signup_error){echo $signup_message;} ?></h4>
                        </div>

                        <div class="login_box">
                            <i class='bx bx-id-card login_icon'></i>
                            <input type="text" placeholder="Name" class="login_input" name="name">
                        </div>
    
                        <div class="login_box">
                            <i class='bx bx-user login_icon'></i>
                            <input type="text" placeholder="Username" class="login_input" name="username">
                        </div>
    
                        <div class="login_box">
                            <i class='bx bx-at login_icon'></i>
                            <input type="text" placeholder="Email" class="login_input" name="email">
                        </div>

                        
                        <div class="input">
                            <div class="input__overlay" id="input-overlay-up"></div>

                            <i class='bx bx-lock-alt input__lock'></i>
                            <input type="password" placeholder="Password" class="input__password" id="input-pass-up" name="password">
                            <i class='bx bx-hide input__icon' id="input-icon-up"></i>
                        </div>

                        
                        <input type="hidden" name="target" value="signup">
                        <a onclick="this.parentElement.submit()" href="#" class="login_button">Sign Up</a>

                        <div>
                            <span class="login_account">Already have an Account ?</span>
                            <span class="login_signup" id="sign-in">Sign In</span>
                        </div>

                        <div class="login_social">
                            
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!--===== MAIN JS =====-->
        <script src="../assets/js/login.js?v=<?php echo time(); ?>"></script>
    </body>
</html>