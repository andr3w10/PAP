<?php
session_start();

	include("../php/connection.php");
	include("../php/functions.php");

	$user_data = check_login($con, false);
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
        <link rel="stylesheet" href="../assets/css/index_styles.css?v=<?php echo time(); ?>">

        <title>The Lost Hero</title>


    <?php include("preloader.php"); ?>


        <!--=============== HEADER ===============-->
        <header class="header" id="header">
            <nav class="nav container">
                <a href="#" class="nav_logo">
                    <img src="../assets/img/page/head.png" alt="" class="nav_logo-img"></img>
                    <h4 class="nav_logo-txt">The Lost Hero</h4>
                </a>
                <div class="nav_menu" id="nav-menu">
                    <ul class="nav_list">
                        <li class="nav_item">
                            <a href="#home" class="nav_link">Home</a>
                        </li>
                        <li class="nav_item">
                            <a href="#journal" class="nav_link">Journal</a>
                        </li>
                        <li class="nav_item">
                            <a href="#store" class="nav_link">Store</a>
                        </li>
                        <li class="nav_item">
                            <a href="#downloads" class="nav_link">Downloads</a>
                        </li>
                        <li class="nav_item">
                            <a href="#about" class="nav_link">About</a>
                        </li>
                        <li class="nav_item">
                            <a href="#footer" class="nav_link">Contact Me</a>
                        </li>
                        

                        <?php if($user_data == null){
                                    echo "<a href='login.php' class ='button button--ghost'>Login</a>";
                                }else{ ?>

                                    <!-- DROPDOWN -->
                                    <div class="sec-center"> 	
                                        <input class="dropdown dropcheck" type="checkbox" id="dropdown" name="dropdown"/>
                                        <label class="for-dropdown" for="dropdown"><?php echo $user_data['name']; ?><i class='bx bx-down-arrow-alt'></i></label>
                                        <div class="section-dropdown"> 
                                            <input class="dropdown-sub dropcheck" type="checkbox" id="dropdown-sub" name="dropdown-sub"/>
                                            <label class="for-dropdown-sub" for="dropdown-sub">Account <i class='bx bx-plus'></i></label>
                                            <div class="section-dropdown-sub"> 
                                                <a href="settings.php" class="a-dropdown">Settings <i class='bx bx-right-arrow-alt' ></i></a>
                                                <a href="purchases.php" class="a-dropdown">Purchases <i class='bx bx-right-arrow-alt' ></i></a>
                                                <a href="../php/logout.php" class="a-dropdown">Logout <i class='bx bx-right-arrow-alt' ></i></a>
                                            </div>
                                            <a href="discount_code.php" class="a-dropdown">Discount Code <i class='bx bx-right-arrow-alt' ></i></a>
                                            <a href="store.php" class="a-dropdown">Language <i class='bx bx-right-arrow-alt' ></i></a>
                                        </div>
                                    </div>       

                                <?php }
                        ?>  

                    </ul>

                    <div class="nav_close" id="nav-close">
                        <i class="bx bx-x"></i>
                    </div>

                    <a href="#"><img src="../assets/img/page/logo.png" class="nav_img"></a>
                </div>

                <div class="nav_toggle" id="nav-toggle">
                    <i class="bx bx-grid-alt"></i>
                </div>
            </nav>
        </header>

        <main class="main">
            <!--==================== HOME ====================-->
            <section class="home container" id="home">
                <div class="swiper home-swiper">
                    <div class="swiper-wrapper">
                        <!-- HOME SLIDER 1 -->
                        <section class="swiper-slide">
                            <div class="home_content grid">
                                <div class="home_group">
                                    <img src="../assets/img/home/logo.png" alt="" class="home_img">
                                    <div class="home_indicator"></div>
    
                                    <div class="home_details-img">
                                        <h4 class="home_details-title">The Lost Hero</h4>
                                        <span class="home_details-subtitle">Awesome Game</span>
                                    </div>
                                </div>
    
                                <div class="home_data">
                                    <h3 class="home_subtitle">find the way home...</h3>
                                    <h1 class="home_title">THE <br> LOST <br> HERO</h1>
                                    <p class="home_description">Hi, I'm Andr3w, I'm a software engineer student and I'm currently working on a game project! Please let me know what u think about it!</p>

                                    <div class="home_buttons">
                                        <a href="#downloads" class="button">Download Now</a>
                                        <a href="#footer" class="button--link button--flex">Share ur thoughts <i class='bx bx-right-arrow-alt button_icon'></i></a>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- HOME SLIDER 2 -->
                        <section class="swiper-slide">
                            <div class="home_content grid">
                                <div class="home_group">
                                    <img src="../assets/img/home/home2.png" alt="" class="home_img">
                                    <div class="home_indicator"></div>
    
                                    <div class="home_details-img">
                                        <h4 class="home_details-title">Sword</h4>
                                        <span class="home_details-subtitle">item</span>
                                    </div>
                                </div>
    
                                <div class="home_data">
                                    <h3 class="home_subtitle">is good and cheap</h3>
                                    <h1 class="home_title">Iron <br> Sword</h1>
                                    <p class="home_description">be carefull because this item can be not very effective against bosses!</p>

                                    <div class="home_buttons">
                                        <a href="#store" class="button">Buy Now</a>
                                        <a href="#footer" class="button--link button--flex">Share ur thoughts <i class='bx bx-right-arrow-alt button_icon'></i></a>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- HOME SLIDER 3 -->
                        <section class="swiper-slide">
                            <div class="home_content grid">
                                <div class="home_group">
                                    <img src="../assets/img/home/home3.png" alt="" class="home_img">
                                    <div class="home_indicator"></div>
    
                                    <div class="home_details-img">
                                        <h4 class="home_details-title">Fox</h4>
                                        <span class="home_details-subtitle">skin</span>
                                    </div>
                                </div>
    
                                <div class="home_data">
                                    <h3 class="home_subtitle">Making u run faster...</h3>
                                    <h1 class="home_title">READY <br> FOR THE <br> HUNTING!</h1>
                                    <p class="home_description">In search for a home and for someone to play with me!</p>

                                    <div class="home_buttons">
                                        <a href="#store" class="button">Buy Now</a>
                                        <a href="#footer" class="button--link button--flex">Share ur thoughts <i class='bx bx-right-arrow-alt button_icon'></i></a>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>

                    <div class="swiper-pagination"></div>
                </div>
            </section>

            <!--==================== JOURNAL ====================-->
            <section class="section journal" id="journal">
                <div class="journal_container container grid">
                    <div class="jornal_data">
                        <h2 class="section_title about_title">Journal</h2>
                        <p class="about_description">Here you can more easily see all the news and evolutions of the game. If, for any reason, there is a bug, it will also be announced here, so, stay tuned!</p>

                        <div class="journal_list_container">
                            <li>
                                Currently working on the website
                            </li>
                            <li>
                                New game logo is out!
                            </li>
                            <li>
                                Release date -> unknown
                            </li>
                        </div>
                    </div>
                </div>
            </section>

            <!--==================== STORE ====================-->
            <section id="store">
                <!-- NEW ARRIVALS --> <!--
                <section class="section new">
                    <h2 class="section_title">New Arrivals</h2>

                    <div class="new_container container">
                        <div class="swiper new-swiper">
                            <div class="swiper-wrapper">
                                <div class="new_content swiper-slide">
                                    <div class="new_tag">New</div>
                                    <img src="../assets/img/store/new_arrivals/new1.png" alt="" class="new_img">
                                    <h3 class="new_title">Iron Sword</h3>
                                    <span class="new_subtitle">item</span>
                                    
                                    <div class="new_prices">
                                        <span class="new_price">25 <i class="bx bx-coin-stack"></i></span>
                                        <span class="new_old_price">50 <i class="bx bx-coin-stack"></i></span>
                                    </div>

                                    <button class="button new_button">
                                        <i class='bx bx-cart-alt new_icon'></i>
                                    </button>
                                </div>
            
                                <div class="new_content swiper-slide">
                                    <div class="new_tag">New</div>
                                    <img src="../assets/img/store/new_arrivals/new2.png" alt="" class="new_img">
                                    <h3 class="new_title">Berry</h3>
                                    <span class="new_subtitle">item (pack of 5)</span>
            
                                    <div class="new_prices">
                                        <span class="new_price">5 <i class="bx bx-coin-stack"></i></span>
                                        <span class="new_old_price">10 <i class="bx bx-coin-stack"></i></span>
                                    </div>

                                    <button class="button new_button">
                                        <i class='bx bx-cart-alt new_icon'></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                                -->

                <!-- SALE -->  <!--
                <section class="section sale">
                    <div class="sale_container container grid">
                        <img src="../assets/img/store/sales.png" alt="" class="sale_img">

                        <div class="sale_data">
                            <h2 class="sale_title">50% Discount <br> On New Products</h2>
                            <a href="#" class="button">Go to new</a>
                        </div>
                    </div>
                </section>
                        -->

                <!-- STORE -->
                <section class="section store">
                    <h2 class="section_title">Store</h2>

                    <!--
                    <div class="store_container container grid">
                        <div class="store_content">
                            <img src="../assets/img/store/default/store1.png" class="store_img">
                            <h3 class="store_title">Goblin</h3>
                            <span class="store_subtitle">skin</span>
                            <span class="store_price">20 <i class="bx bx-coin-stack"></i></span>

                            <button class="button store_button">
                                <i class="bx bx-cart-alt store_icon"></i>
                            </button>
                        </div>

                        <div class="store_content">
                            <img src="../assets/img/store/default/store2.png" class="store_img">
                            <h3 class="store_title">Fox</h3>
                            <span class="store_subtitle">skin</span>
                            <span class="store_price">100 <i class="bx bx-coin-stack"></i></span>

                            <button class="button store_button">
                                <i class="bx bx-cart-alt store_icon"></i>
                            </button>
                        </div>

                        <div class="store_content">
                            <img src="../assets/img/store/default/store3.png" class="store_img">
                            <h3 class="store_title">Bread</h3>
                            <span class="store_subtitle">item (pack of 8)</span>
                            <span class="store_price">15 <i class="bx bx-coin-stack"></i></span>

                            <button class="button store_button">
                                <i class="bx bx-cart-alt store_icon"></i>
                            </button>
                        </div>
                    </div> -->

                    <br>

                    <?php
                        if($user_data == null){
                            echo '<form action="login.php" method="get" id="hidden_form">
                                    <a class="button" onclick="login_redirect()">See More</a>
                                    <input type="hidden" name="to" id="redirect_to" value="store">
                                </form>';
                        }else{
                            echo '<a href="store.php" class="button">See More</a>';
                        }
                    ?>
                    
                </section>
                </section>

            <!--==================== DOWNLOADS ====================-->
            <section class="section downloads" id="downloads">
                <div class="downloads_container container grid">
                    <img src="../assets/img/downloads/download.png" alt="" class="downloads_img">

                    <div class="downloads_data">
                        <h2 class="downloads_title">Click in the button bellow <br> to go to the <br> Downloads page</h2>
                        <a href="#" class="button">Go to Downloads</a>
                    </div>
                </div>
            </section>

            <!--==================== ABOUT ====================-->
            <section class="section about" id="about">
                <div class="about_container container grid">
                    <div class="about_data">
                        <h2 class="section_title about_title">About the game <br> The Lost Hero</h2>
                        <p class="about_description">This game is currently being made by Andr3w, a software engineer student, for a college project! Please download the game and give it a try! <br>Thx! :)</p>
                    </div>
                </div>
            </section>
        </main>

        <!--==================== FOOTER ====================-->
        <footer class="footer section" id="footer">
            <div class="footer_container container grid">
                <div class="footer_content">
                    <h3 class="footer_title">About</h3>
                    
                    <ul class="footer_links">
                        <li>
                            <a href="#about" class="footer_link">About Me</a>
                        </li>
                        <li>
                            <a href="#about" class="footer_link">Career</a>
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
                            <a href="#about" class="footer_link">About</a>
                        </li>
                        <li>
                            <a href="#downloads" class="footer_link">Downloads</a>
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

        <!--=============== SCROLL UP ===============-->
        <a href="#" class="scrollup" id="scroll-up">
            <i class='bx bx-up-arrow-alt scrollup_icon'></i>
        </a>

        <!--=============== SWIPER JS ===============-->
        <script src="../assets/js/swiper-bundle.min.js"></script>

        <!--=============== MAIN JS ===============-->
        <script src="../assets/js/main.js?v=<?php echo time(); ?>"></script>
    </body>
</html>