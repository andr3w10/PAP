<?php
session_start();

    if (isset($_POST["checkout_item_id"]) || isset($_POST["checkout_item_quantity"])){

    }else{
        header("location: ../html/store.php");
    }

    $item_id = 0;

	include("../php/connection.php");
    include("../php/functions.php");

    //read from database
    $item_id = $_POST["checkout_item_id"];
    $query = "select * from store where id = '$item_id' limit 1";
    $result = mysqli_query($con, $query);
    $item_data = mysqli_fetch_assoc($result);

    $user_id = $_SESSION['username'];
    $query = "select * from users where username = '$user_id' limit 1";
    $result = mysqli_query($con,$query);
    $user_data = mysqli_fetch_assoc($result);

    $checkout_quantity = $_POST["checkout_item_quantity"];
    $item_price = get_new_price($item_data['price']);
    $total_price = $item_price * $checkout_quantity;
    $user_updated_coins = $user_data['coins'] - $total_price;
    $date= date("Y-m-d");

    if ($user_updated_coins >= 0){
        //update the database discount code
        if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount']))
        {
            $code = $_SESSION['discount_code'];
            $query = "update discount_codes set uses = (uses + 1) where code = '$code'";
            $result = mysqli_query($con,$query);
            if(!$result){
                echo("Error description: " . mysqli_error($con));
                die;
            }
        }

        //update the database
        $query = "update users set coins = $user_updated_coins where username = '$user_id'";
        $result = mysqli_query($con,$query);
        if(!$result){
            echo("Error description: " . mysqli_error($con));
            die;
        }

        //see how many rows it have
        $query = "select * from purchases";
        $result = mysqli_query($con, $query);
        $size = 0;
        foreach($result as $row){
            $size += 1;
        }
        $size += 1;

        //insert in purchase
        $query = "insert into purchases (id,username,item_id,item_quantity,spent_coins,purchase_date) values ('$size','$user_id','$item_id','$checkout_quantity','$total_price', '$date')";
        $result = mysqli_query($con, $query);
        if(!$result){
            echo("Error description: " . mysqli_error($con));
            die;
        }

        //insert in to_claim
        $query = "insert into to_claim (purchase_id, quantity) values ('$size', '$checkout_quantity')";
        $result = mysqli_query($con, $query);
        if(!$result){
            echo("Error description: " . mysqli_error($con));
            die;
        }

        $GLOBALS['purchased'] = true;
    }else{
        $GLOBALS['purchased'] = false;
    }


    $user_data = check_login($con, true);
    header( "Refresh:10; url=../html/store.php");
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

        <title>The Lost Hero</title>




        <?php include("preloader.php"); ?>



        <!--=============== HEADER ===============-->
        <header class="header" id="header">
            <nav class="nav container">
                <a href="../html/index.php" class="nav_logo">
                    <img src="../assets/img/page/head.png" alt="" class="nav_logo-img"></img>
                    <h4 class="nav_logo-txt">The Lost Hero</h4>
                </a>
                
            </nav>
        </header>
        <main class="main">
            <!--==================== STORE ====================-->
            <section id="store">

                <!-- STORE -->
                        <?php
                            $item_id = $_POST["checkout_item_id"];

                            //read from database
                            $query = "select * from store where id = '$item_id' limit 1";
                            $store_data = mysqli_query($con, $query);

                            $id = $_SESSION['username'];
		                    $query = "select * from users where username = '$id' limit 1";
                            $result = mysqli_query($con,$query);
                            $user_data = mysqli_fetch_assoc($result);

                            if($store_data)
                            {
                                if($store_data && mysqli_num_rows($store_data) > 0)
                                {
                                    foreach($store_data as $item_data){
                                        $checkout_quantity = $_POST["checkout_item_quantity"];

                                        $item_name = $item_data['name'];
                                        $item_price = get_new_price($item_data['price']);
                                        $item_type = $item_data['type'];
                                        $item_img_location = $item_data['img_location'];

                                        $total_price = $item_price * $checkout_quantity;
                                        $user_updated_coins = $user_data['coins'];

                                        if (!isset($GLOBALS['purchased'])){
                                            die;
                                        }

                                        if ($GLOBALS['purchased'] == true){
                                            echo '<section class="section purchase">';
                                            echo '<br><h2 class="section_title">Thank You for Your Purchase</h2><br>';
                                            echo '<div class="purchased_store_container purchase_container grid">';

                                            echo "<span class='purchased_store_text'>( ".$total_price." <i class='bx bx-coin-stack'></i> spent in total )</span><br>";

                                            echo "<div class='purchased_content_div'>";
                                            echo "<img src=".$item_img_location." class='purchased_store_img'><br>";
                                            echo "<h3 class='purchased_store_title'>".$item_name."</h3>";
                                            echo "<span class='purchased_store_subtitle'>".$item_type."</span>";
                                            echo "<span class='purchased_store_price'>".$item_price." <i class='bx bx-coin-stack'></i>&ensp; X ".$checkout_quantity."</span></div>";
                                        }else{
                                            echo "<section class='section purchase'>";
                                            echo "<br><h2 class='section_title'>You dont have enough coins to complete this purchase!</h2><br>";
                                            echo "<div class='purchased_store_container purchase_container grid'>";

                                            echo "<span class='purchased_store_text'>( ".$total_price." <i class='bx bx-coin-stack'></i> needed in total )</span><br>";

                                            echo "<div class='purchased_content_div'>";
                                            echo "<img src=".$item_img_location." class='purchased_store_img'><br>";
                                            echo "<h3 class='purchased_store_title'>".$item_name."</h3>";
                                            echo "<span class='purchased_store_subtitle'>".$item_type."</span>";
                                            echo "<span class='purchased_store_price'>".$item_price." <i class='bx bx-coin-stack'></i>&ensp; X ".$checkout_quantity."</span></div>";
                                        }
                                    }
                                }
                            }
                            unset($_POST["checkout_item_id"]);
                            unset($_POST["checkout_item_quantity"]);
                        ?>
                    </div>
                </section>
            </section>
        </main>
        <span class="footer_copy">Redirecting to <a href="../html/store.php">store</a> in 10 seconds</span>
        <span class="footer_copy">&#169; Andr3w. All rigths reserved</span>

        <!--==================== FOOTER ====================-->
        <footer class="footer section" id="footer">

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