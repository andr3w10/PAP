<?php 
session_start();

    $item_id = 0;

	include("../php/connection.php");
	include("../php/functions.php");

	$user_data = check_login($con, true);

    $show_errors_msg = false;
    $errors_text = "";
    if(isset($_SESSION['errors_text']) && $_SESSION['errors_text'] != "" && $_SESSION['errors_text'] != "none"){
        $errors_text = $_SESSION['errors_text'];
        $show_errors_msg = true;
        unset($_SESSION['errors_text']);
    }
?>

<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!--=============== PAGEICON ===============-->
        <link rel="shortcut icon" href="../assets/img/page/head.png" type="image/x-icon">

        <!--=============== BOXICONS ===============-->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">

        <!--=============== SWIPER CSS ===============--> 
        <link rel="stylesheet" href="../assets/css/swiper-bundle.min.css">

        <!--=============== CSS ===============--> 
        <link rel="stylesheet" href="../assets/css/settings.css?v=<?php echo time(); ?>">


        <title>The Lost Hero</title>


        <?php include("preloader.php"); ?>



        <!--=============== HEADER ===============-->
        <header class="header" id="header">
            <nav class="nav container">
                <a href="index.php" class="nav_logo">
                    <img src="../assets/img/page/head.png" alt="" class="nav_logo-img"></img>
                    <h4 class="nav_logo-txt">The Lost Hero</h4>
                </a>

                <div class="nav_menu">
                    <h1 >S E T T I N G S</h1>
                </div>
            </nav>
        </header>

        <main class="main">
            <br><br><br>
            
            <?php
                $username = $_SESSION['username'];
                //read from database
                $query = "select * from users where username = '$username' limit 1";
                $result = mysqli_query($con, $query);
    
                if($result)
                {
                    if($result && mysqli_num_rows($result) > 0)
                    {
    
                        $user_data = mysqli_fetch_assoc($result);
                        
                        $curr_username = $user_data['username'];
                        $curr_name = $user_data['name'];
                        $curr_email = $user_data['email'];
                    }
                }
            ?>

            <?php if($show_errors_msg){//error on save?>
                <div class="form-style-5 errors">
                    <center><label class="error"><?php echo $errors_text ?></label></center>
                </div>
            <?php }else{
                if(isset($_SESSION['errors_text'])){
                    if($_SESSION['errors_text'] == "none"){
                        unset($_SESSION['errors_text']);
                        //save completed
                        ?>
                            <div class="form-style-5 saved-div">
                                <center><label class="saved_lbl"><?php echo "Account settings saved successfuly!" ?></label></center>
                            </div>
                        <?php
                    }
                }
            }?>

            <div class="form-style-5">
                <form action="../php/apply_account_infos.php" method="POST" >
                    <fieldset>
                        <legend><span class="number">1</span> Account Info</legend>
                        <label >Username</label>
                        <input type="text" name="username" placeholder="<?php echo $curr_username; ?>">
                        <label >Full Name</label>
                        <input type="text" name="full_name" placeholder="<?php echo $curr_name; ?>">
                        <label >Email</label>
                        <input type="email" name="email" placeholder="<?php echo $curr_email; ?>">
                        <!-- <textarea name="field3" placeholder="About yourself"></textarea>
                        <label >Interests:</label>
                        <select id="job" name="field4">
                            <optgroup label="Indoors">
                                <option value="fishkeeping">Fishkeeping</option>
                                <option value="reading">Reading</option>
                                <option value="boxing">Boxing</option>
                                <option value="debate">Debate</option>
                                <option value="gaming">Gaming</option>
                                <option value="snooker">Snooker</option>
                                <option value="other_indoor">Other</option>
                            </optgroup>
                            <optgroup label="Outdoors">
                                <option value="football">Football</option>
                                <option value="swimming">Swimming</option>
                                <option value="fishing">Fishing</option>
                                <option value="climbing">Climbing</option>
                                <option value="cycling">Cycling</option>
                                <option value="other_outdoor">Other</option>
                            </optgroup>
                        </select>  --> 
                    </fieldset>
                    <fieldset>
                        <legend><span class="number">2</span> Security</legend>
                        <label >New Password</label>
                        <input type="password" name="n_password" placeholder="">
                        <label >Repeat Password</label>
                        <input type="password" name="r_password" placeholder="">
                    </fieldset>
                    
                    <br>

                    <fieldset>
                        <legend><span class="number">3</span> Save</legend>
                        <label >Password</label>
                        <input type="password" name="curr_password" placeholder="">
                    </fieldset>

                    <input type="submit" class="submit_btn" value="Save" />
                </form>
            </div>
            
        </main>


        <!--==================== FOOTER ====================-->
        <footer class="footer section" id="footer">
            <span class="footer_copy">&#169; Andr3w. All rigths reserved</span>
        </footer>

        <!--=============== SCROLL UP ===============-->
        <a href="#" class="scrollup" id="scroll-up">
            <i class='bx bx-up-arrow-alt scrollup_icon'></i>
        </a>

        <!--=============== SWIPER JS ===============-->
        <script src="../assets/js/swiper-bundle.min.js"></script>

        <!--=============== MAIN JS ===============-->
        <script src="../assets/js/settings.js?v=<?php echo time(); ?>"></script>
    </body>
</html>