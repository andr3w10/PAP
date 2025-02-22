<?php
session_start();

	include("../php/connection.php");
	include("../php/functions.php");

	$user_data = check_login($con, false);



    if(isset($_SESSION['error'])){
        $GLOBALS['error'] = $_SESSION['error'];
        unset($_SESSION['error']);
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
        <link rel="stylesheet" href="../assets/css/discount_code.css?v=<?php echo time(); ?>">


        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>



        <title>The Lost Hero</title>


    <?php include("preloader.php"); ?>


        <!--=============== HEADER ===============-->
        <header class="header" id="header">
            <nav class="nav container">
                <a href="index.php" class="nav_logo">
                    <img src="../assets/img/page/head.png" alt="" class="nav_logo-img"></img>
                    <h4 class="nav_logo-txt">The Lost Hero</h4>
                </a>
            </nav>
        </header>

        

        <main class="main">

            <section class="section">
                <h2 class="section_title">Apply Discount Code</h2>
            </section>

            <div class="search-wrapper active">
                <div class="input-holder">
                    <input type="text" class="search-input" id="search_box" placeholder="<?php
                    if(isset($GLOBALS['error'])){
                        if($GLOBALS['error'] != ""){
                            ?> <?php echo $GLOBALS['error'] ?> <?php
                        }
                        unset($GLOBALS['error']);
                    }elseif(isset($_SESSION['discount_code'])){
                        if($_SESSION['discount_code'] != ""){
                            ?> Code '<?php echo $_SESSION['discount_code'] ?>' is applied! <?php
                        }
                    }else{
                        echo "Type to search";
                    }
                    ?>" />
                    <button class="search-icon" onclick="searchToggle(this, event);"><span></span></button>
                </div>
                <span class="close" onclick="searchToggle(this, event);"></span>
            </div>            

            <form action="../php/apply_discount_code.php" method="get" id="hidden_form">
                <input type="hidden" id="hidden_input" name="code"></input>
            </form>
            
            <center>
            <?php
                    /*if(isset($GLOBALS['error'])){
                        if($GLOBALS['error'] != ""){
                            ?> <span class="section_subtitle error"> <?php echo $GLOBALS['error'] ?> </span> <?php
                        }
                        unset($GLOBALS['error']);
                    }else{
                        if(isset($_SESSION['discount_code'])){
                            if($_SESSION['discount_code'] != ""){
                                ?> <span class="section_subtitle success"> Currently, you have the code '<?php echo $_SESSION['discount_code'] ?>' applied! </span> <?php
                            }
                        }
                    } */
                ?>
            </center>
            
                
          
                

        </main>

        
        <!--==================== FOOTER ====================-->
        <footer class="footer section" id="footer">
            <div class="footer_container container grid">
                <div class="footer_content">
                    <h3 class="footer_title">About</h3>
                    
                    <ul class="footer_links">
                        <li>
                            <a href="#" class="footer_link">About Me</a>
                        </li>
                        <li>
                            <a href="#" class="footer_link">Career</a>
                        </li>
                        <li>
                            <a href="mailto:andr3w.devpt@gmail.com?" class="footer_link">Contact me</a>
                        </li>
                    </ul>
                </div>

                <div class="footer_content">
                    <h3 class="footer_title">Socials</h3>
                    
                    <ul class="footer_links">
                        <li>
                            <a href="https://discord.com/invite/gQjhQ2Qwg5" class="footer_link">Discord <i class='bx bxl-discord'></i></a>
                        </li>
                        <li>
                            <a href="https://www.instagram.com/thelosthero.game/" class="footer_link">Instagram <i class='bx bxl-instagram-alt' ></i></a>
                        </li>
                        <li>
                            <a href="https://twitter.com/_thelosthero/" class="footer_link">Twitter <i class='bx bxl-twitter' ></i></a>
                        </li>
                    </ul>
                </div>

                <div class="footer_content">
                    <h3 class="footer_title">The Lost Hero</h3>
                    
                    <ul class="footer_links">
                        <li>
                            <a href="index.php#about" class="footer_link">About</a>
                        </li>
                        <li>
                            <a href="index.php#downloads" class="footer_link">Downloads</a>
                        </li>
                        <li>
                            <a href="store.php" class="footer_link">Game Store</a>
                        </li>
                    </ul>
                </div>
            </div>

            <span class="footer_copy">&#169; Andr3w. All rigths reserved</span>

            <img src="../assets/img/page/footer1.png" alt="" class="footer_img-one">
            <img src="../assets/img/page/footer1.png" alt="" class="footer_img-two">
        </footer>

        <!--=============== MAIN JS ===============-->
        <script src="../assets/js/discount_code.js?v=<?php echo time(); ?>"></script>
    </body>
</html>