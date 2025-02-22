<?php 
session_start();

    $item_id = 0;

	include("../php/connection.php");
	include("../php/functions.php");

	$user_data = check_login($con, true);
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
        <link rel="stylesheet" href="../assets/css/store_styles.css?v=<?php echo time(); ?>">

        <link rel="stylesheet" href="fontawesome-free-5.15.1/css/all.css">

        <script src="https://kit.fontawesome.com/afd6aa68df.js" crossorigin="anonymous"></script>

        <script src="https://code.iconify.design/2/2.1.2/iconify.min.js"></script>

        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.0/TweenMax.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.1/utils/Draggable.min.js"></script>


        <title>The Lost Hero</title>

        <!-- Including jQuery is required. -->
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
        <!-- Including our scripting file. -->
        <script type="text/javascript" src="search.js?v=<?php echo time(); ?>"></script>
        
    

        <?php include("preloader.php"); ?>



        <!--=============== HEADER ===============-->
        <header class="header" id="header">
            <nav class="nav container">
                <a href="index.php" class="nav_logo">
                    <img src="../assets/img/page/head.png" alt="" class="nav_logo-img"></img>
                    <h4 class="nav_logo-txt">The Lost Hero</h4>
                </a>

                <div class="box" id="search_bar">
                    <form name="search" onsubmit="return false">
                        <input type="text" id="search" class="input search"
                        onfocusout="document.search.search.value = ''" autocomplete="off">
                    </form>
                        <i class="fas fa-search i-search"></i>
                </div>

                <div class="nav_menu" id="nav-menu">
                    
                    <ul class="nav_list">
                        <li class="nav_item">
                            <a href="store.php#item" class="nav_link">Items</a>
                        </li>
                        <li class="nav_item">
                            <a href="store.php#skin" class="nav_link">Skins</a>
                        </li>
                        <li class="nav_item">
                            <a href="store.php#pet" class="nav_link">Pets</a>
                        </li>
                        <li class="nav_item">
                            <a href="store.php#decoration" class="nav_link">Decoration</a>
                        </li>
                        

                        <a href="#" class="button button--coins"> <i class='bx bx-coin-stack'></i> <?php echo $user_data['coins']; ?> </a>
                        

                        <?php if($user_data == null){
                                    echo "<a href='login.php' class ='button button--ghost'>Login</a>";
                                }else{ ?>
                                
                                        <!-- DROPDOWN -->
                                        <div class="sec-center"> 	
                                            <input class="dropdown dropcheck" type="checkbox" id="dropdown" name="dropdown"/>
                                            <label class="for-dropdown" for="dropdown"><?php echo $user_data['name']; ?><i class='bx bx-down-arrow-alt'></i></label>
                                            <div class="section-dropdown"> 
                                                <a onclick="filtersMenu()" class="a-dropdown">Filters <i class='bx bx-right-arrow-alt' ></i></a>
                                                <input class="dropdown-sub dropcheck" type="checkbox" id="dropdown-sub" name="dropdown-sub"/>
                                                <label class="for-dropdown-sub" for="dropdown-sub">Account <i class='bx bx-plus'></i></label>
                                                <div class="section-dropdown-sub"> 
                                                    <a href="settings.php" class="a-dropdown">Settings <i class='bx bx-right-arrow-alt' ></i></a>
                                                    <a href="purchases.php" class="a-dropdown">Purchases <i class='bx bx-right-arrow-alt' ></i></a>
                                                    <a href="../php/logout.php" class="a-dropdown">Logout <i class='bx bx-right-arrow-alt' ></i></a>
                                                </div>
                                                <a href="discount_code.php" class="a-dropdown">Discount Code <i class='bx bx-right-arrow-alt' ></i></a>
                                                <a href="#" class="a-dropdown">Language <i class='bx bx-right-arrow-alt' ></i></a>
                                            </div>
                                        </div>       

                                    <?php }
                        ?>  
                        
                    </ul>
                    

                    <div class="nav_close" id="nav-close">
                        <i class="bx bx-x"></i>
                    </div>

                    <img src="../assets/img/page/logo.png" alt="" class="nav_img">
                </div>

                <div class="nav_toggle" id="nav-toggle">
                    <i class="bx bx-grid-alt"></i>
                </div>
            </nav>        
        </header>

        
        <main id="filters_main" class="main hide_main">
            <section class="section store">
                <h2 class="section_title">Store</h2>

                <!-- FILTERS -->
                    <?php
                        $protocol = ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
                        
                        $url = $protocol . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];

                        $components = parse_url($url);
                        parse_str($components['query'], $results);
                        $filters = $results['filters'];

                        //format filters text to variables
                        $price = "";
                        $types = array();
                        $type_num = -1;
                        $temp = "";
                        $op = -1;

                        for($i=0; $i < strlen($filters); $i++){
                            $temp .= $filters[$i];


                            if($filters[$i] == "%"){
                                $temp = "";
                                $op = -1;
                            }



                            if($op == 0){ // price
                                $price .= $filters[$i];
                            }

                            if($op == 1){ // types
                                if($filters[$i] == " "){
                                    $type_num++;
                                    $types[$type_num] = "";
                                }else{
                                    $types[$type_num] .= $filters[$i];
                                }
                            }



                            if($temp == "price="){
                                $temp = "";
                                $op = 0;
                            }

                            if($temp == "types="){
                                $temp = "";
                                $op = 1;
                            }
                        }

                        $types_query = "";

                        for($i=0; $i < sizeof($types); $i++){
                            if($i == 0){
                                $types_query .= " and (type like '$types[$i]'";
                            }else{
                                $types_query .= " or type like '$types[$i]'";
                            }

                            if($types[$i] == "item"){
                                $max = strlen($types_query);
                                $types_query[$max - 1] = "%";
                                $types_query .= "'";
                            }
                        }
                        if($types_query != ""){
                            $types_query .= ")";
                        }

                        $query = "select * from store where price <= $price" . $types_query;

                        //read from database
                        $store_data = mysqli_query($con, $query);

                        if($store_data)
                        {
                            if($store_data && mysqli_num_rows($store_data) > 0)
                            {    
                                echo "<h2 class='section_subtitle' id='searched_items'>SEARCHED ITEMS</h2>";
                                echo "<div class='store_container container grid'>";    
                                
                                foreach($store_data as $item){
                                    if($item['is_exclusive']==false){
                                        if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                            <div class='store_content'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <div class="sale_prices">
                                                <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                            </div>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                        }else{ ?>
                                        <div class='store_content'>
                                        <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                        <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                        <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                        <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                        <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                        }
                                    }
                                }
                            }else{
                                echo "<h2 class='section_subtitle' id='item'>SEARCHED ITEMS</h2>";
                                echo "<span>Items not found</span>";
                                echo "</div><br><br><br><br><br>";
                            }
                        }
                    ?>
                </div>

                <br><br>
            </section>

            <!--==================== FILTERS MENU ====================-->
            <section class="checkout container">
                <div class="checkout_container show-checkout" id="filters-container">
                    <div class="filters_content">
                        <div class="checkout_close close-filters" title="Close">
                            <i class='bx bx-x'></i>
                        </div>

                        <h1 class="checkout_title">Filters</h1>
                        
                        <p class="checkout_description">Chose your filters</p>

                        

                        <center><div class="cbx_container">
                            <ul class="ks-cboxtags">
                                <li><input type="checkbox" id="checkbox_items" value="items"><label for="checkbox_items">Items</label></li>
                                <li><input type="checkbox" id="checkbox_pets" value="pets"><label for="checkbox_pets">Pets</label></li>
                                <li><input type="checkbox" id="checkbox_skins" value="skins"><label for="checkbox_skins">Skins</label></li>
                                <li><input type="checkbox" id="checkbox_decoration" value="decoration"><label for="checkbox_decoration">Decoration</label></li>
                            </ul>
                        </div></center>

                        <br>

                        

                        <br><p class="checkout_description">Set your budget</p>

                        <center><div class="slider_body">
                            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 225 600 125">
                                <defs>
                                    <filter id="goo" color-interpolation-filters="sRGB">
                                        <feGaussianBlur in="SourceGraphic" stdDeviation="8" result="blur" />
                                        <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 21 -7" result="cm" />
                                    </filter>
                                </defs>
                                <g id="dragGroup">
                                    <path id="dragBar" fill="#FFFFFF" d="M447,299.5c0,1.4-1.1,2.5-2.5,2.5h-296c-1.4,0-2.5-1.1-2.5-2.5l0,0c0-1.4,1.1-2.5,2.5-2.5
                                        h296C445.9,297,447,298.1,447,299.5L447,299.5z" />
                                    <g id="displayGroup">
                                        <g id="gooGroup" filter="url(#goo)">
                                            <circle id="display1" fill="#FFFFFF" cx="146" cy="299.5" r="16" />
                                            <circle id="dragger" fill="#FFFFFF"  stroke="#03A9F4" stroke-width="0" cx="146" cy="299.5" r="15" />
                                        </g>
                                        <text class="downText" x="146" y="304">0</text>
                                        <text class="upText" x="145" y="266">0</text>
                                    </g>
                                </g>
                            </svg>
                        </div></center>
                        <input type="hidden" name="max_price" id="max_price">

                        <a class="button" onclick="apply_filters()">Apply Filters</a>

                    </div>
                </div>
            </section>
        </main>


        <main id="normal_main" class="main show_main">
            <!--==================== STORE ====================-->
            <section id="store">
                <!-- 
                NEW ARRIVALS
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

                SALE
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

                    <!-- SEARCH ITEMS -->
                    <div id="display"></div>

                    <!-- ITEM -->
                    <h2 class="section_subtitle" id="item">ITEMS</h2>     
                    <div class="store_container container grid">
                        <?php
                            //read from database
                            $query = "select * from store where type like 'item%'";
                            $store_data = mysqli_query($con, $query);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {                             
                                    foreach($store_data as $item){
                                        if($item['is_exclusive']==false){
                                            if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                                <div class='store_content'>
                                                <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                                <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                                <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                                <div class="sale_prices">
                                                    <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                    <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                                </div>
                                                <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }else{ ?>
                                            <div class='store_content'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }
                                        }
                                    }
                                }
                            }
                        ?>
                    </div>

                    <br><br><br>
                    <!-- SKIN -->
                    <h2 class="section_subtitle" id="skin">SKINS</h2>     
                    <div class="store_container container grid">
                        <?php
                            //read from database
                            $query = "select * from store where type like 'skin'";
                            $store_data = mysqli_query($con, $query);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {                             
                                    foreach($store_data as $item){
                                        if($item['is_exclusive']==false){
                                            if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                                <div class='store_content'>
                                                <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                                <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                                <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                                <div class="sale_prices">
                                                    <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                    <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                                </div>
                                                <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }else{ ?>
                                            <div class='store_content'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }
                                        }
                                    }
                                }
                            }
                        ?>
                    </div>

                    <br><br><br>
                    <!-- PET -->
                    <h2 class="section_subtitle" id="pet">PETS</h2>     
                    <div class="store_container container grid">
                        <?php
                            //read from database
                            $query = "select * from store where type like 'pet'";
                            $store_data = mysqli_query($con, $query);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {                             
                                    foreach($store_data as $item){
                                        if($item['is_exclusive']==false){
                                            if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                                <div class='store_content'>
                                                <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                                <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                                <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                                <div class="sale_prices">
                                                    <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                    <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                                </div>
                                                <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }else{ ?>
                                            <div class='store_content'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }
                                        }
                                    }
                                }
                            }
                        ?>
                    </div>


                    <br><br><br>
                    <!-- DECORATION -->
                    <h2 class="section_subtitle" id="decoration">DECORATION</h2>     
                    <div class="store_container container grid">
                        <?php
                            //read from database
                            $query = "select * from store where type like 'decoration'";
                            $store_data = mysqli_query($con, $query);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {                             
                                    foreach($store_data as $item){
                                        if($item['is_exclusive']==false){
                                            if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                                <div class='store_content'>
                                                <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                                <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                                <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                                <div class="sale_prices">
                                                    <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                    <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                                </div>
                                                <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }else{ ?>
                                            <div class='store_content'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }
                                        }
                                    }
                                }
                            }
                        ?>
                    </div>

                </section>
            </section>

            
            <!--==================== CHECKOUT ====================-->
            <!-- to store the selected item id -->
            <form id="hidden_form" action="store.php" method="get">
                <input type="hidden" name="selected_item_id" id="selected_item_id">
            </form>

            <section class="checkout container">
                <div class="checkout_container" id="checkout-container">
                    <div class="checkout_content">
                        <div class="checkout_close close-checkout" title="Close">
                            <i class='bx bx-x'></i>
                        </div>

                        <img src="../assets/img/page/logo.png" alt="" class="checkout_img">

                        <h1 class="checkout_title">Purchase</h1>
                        
                        <p class="checkout_description">Click the button to confirm the purchase</p>


                        <?php
                            $item_id = $_GET["selected_item_id"];

                            //read from database
                            $query = "select * from store where id = '$item_id' limit 1";
                            $store_data = mysqli_query($con, $query);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {
                                    foreach($store_data as $item){
                                        if($item['is_exclusive']==false){
                                            if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){ ?>
                                                <div class='checkout_content_div'>
                                                <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                                <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                                <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                                <div class="sale_prices">
                                                    <span class="sale_price"> <?php echo get_new_price($item['price']); ?> <i class="bx bx-coin-stack"></i></span>
                                                    <span class="sale_old_price"> <?php echo $item['price'] ?> <i class="bx bx-coin-stack"></i></span>
                                                </div>
                                                <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }else{ ?>
                                            <div class='checkout_content_div'>
                                            <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                                            <h3 class='store_title'><?php echo $item['name']; ?></h3>
                                            <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                                            <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                                            <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                                            }
                                        }
                                    }
                                          
                                }
                            }
                        ?>


                        <center>
                        <small class="checkout_description">Quantity to purchase</small>
                        <br>
                        <div class="quantity_container">
                            <span class="next" onclick="nextNum()"></span>
                            <span class="prev" onclick="prevNum()"></span>
                            <div id="quantity_box">
                                <!-- the numbers are created in javascript -->
                            </div>
                        </div>
                        </center>

                        <br><button class="checkout_button checkout_button-width" onclick="buy_pressed()">Buy</button>
                    </div>
                </div>

                <form id="checkout_form" action="purchase.php" method="post">
                    <input type="hidden" name="checkout_item_id" id="checkout_item_id" value="<?php if (isset($_GET['selected_item_id'])) {echo $_GET['selected_item_id'];} ?>">
                    <input type="hidden" name="checkout_item_quantity" id="checkout_item_quantity">
                </form>

            </section>
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
        <script src="../assets/js/store.js?v=<?php echo time(); ?>"></script>
    </body>
</html>