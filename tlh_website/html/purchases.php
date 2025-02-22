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
        <link rel="stylesheet" href="../assets/css/purchases.css?v=<?php echo time(); ?>">


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
                    <h1 >P U R C H A S E S</h1>
                </div>
            </nav>
        </header>

        <main class="main">
            <br><br>
            <section class="p_section">
                <div class="tbl-header">
                    <table  class="p_table" cellpadding="0" cellspacing="0" border="0">
                        <thead>
                            <tr class="p_tr">
                                <th class="p_th">Name</th>
                                <th class="p_th">Price</th>
                                <th class="p_th">Type</th>
                                <th class="p_th">Quantity</th>
                                <th class="p_th">Spent Coins</th>
                                <th class="p_th">Purchase Date</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="tbl-content">
                    <table class="p_table" cellpadding="0" cellspacing="0" border="0">
                        <tbody>
                            <?php
                                //read from database
                                $username = $_SESSION['username'];
                                $query = "select purchases.item_quantity, purchases.spent_coins, purchases.purchase_date, store.name, store.price, store.type from purchases inner join store on purchases.item_id = store.id where purchases.username = '$username'";
                                $purchases_data = mysqli_query($con, $query);

                            if($purchases_data)
                            {
                                if($purchases_data && mysqli_num_rows($purchases_data) > 0)
                                {                             
                                    foreach($purchases_data as $purchase){
                                        $item_name = $purchase['name'];
                                        $item_price = $purchase['price'];
                                        $item_type = $purchase['type'];
                                        $item_quantity = $purchase['item_quantity'];
                                        $spent_coins = $purchase['spent_coins'];
                                        $purchase_date = $purchase['purchase_date'];

                                        ?>
                                            <tr class="p_tr">
                                                <td class="p_td"><?php echo $item_name?></td>
                                                <td class="p_td"><?php echo $item_price?></td>
                                                <td class="p_td"><?php echo $item_type?></td>
                                                <td class="p_td"><?php echo $item_quantity?></td>
                                                <td class="p_td"><?php echo $spent_coins?></td>
                                                <td class="p_td"><?php echo $purchase_date?></td>
                                            </tr>
                                        <?php
                                    }
                                }
                            }
                            ?>
                        </tbody>
                    </table>
                </div>
                    <span class="footer_copy">&#169; Andr3w. All rigths reserved</span>
                </section>
        </main>


        <!--==================== FOOTER ====================-->
        

        <!--=============== SCROLL UP ===============-->
        <a href="#" class="scrollup" id="scroll-up">
            <i class='bx bx-up-arrow-alt scrollup_icon'></i>
        </a>

        <!--=============== SWIPER JS ===============-->
        <script src="../assets/js/swiper-bundle.min.js"></script>

        <!--=============== MAIN JS ===============-->
        <script src="../assets/js/purchases.js?v=<?php echo time(); ?>"></script>
    </body>
</html>