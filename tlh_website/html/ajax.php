<?php
session_start();
include("../php/functions.php");
    //Including Database configuration file.
    //Database connection.

    $con = MySQLi_connect(
        "localhost", //Server host name.
        "root", //Database username.
        "", //Database password.
        "tlh_database" //Database name or anything you would like to call it.
        );
        //Check connection
        if (MySQLi_connect_errno()) {
        echo "Failed to connect to MySQL: " . MySQLi_connect_error();
        }


        //$con = MySQLi_connect(
          //  "sql300.epizy.com", //Server host name.
            //"epiz_30578554", //Database username.
            //"bvVd36RzY5iypTO", //Database password.
            //"epiz_30578554_tlh_database" //Database name or anything you would like to call it.
            //);
            //Check connection
            //if (MySQLi_connect_errno()) {
            //echo "Failed to connect to MySQL: " . MySQLi_connect_error();
            //}

    //Getting value of "search" variable from "script.js".
    if (isset($_POST['search'])) {
    //Search box value assigning to $Name variable.
    $name = $_POST['search'];
    //Search query.
    $Query = "SELECT * FROM store WHERE name LIKE '%$name%'";
    //Creating unordered list to display result.
    $store_data = mysqli_query($con, $Query);

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
                    }else{?>
                    <div class='store_content'>
                    <img src=" <?php echo $item['img_location']."?v=".time(); ?>" class='store_img'>
                    <h3 class='store_title'><?php echo $item['name']; ?></h3>
                    <span class='store_subtitle'> <?php echo $item['type']; ?> </span>
                    <span class='store_price'> <?php echo $item['price'] ?> <i class='bx bx-coin-stack'></i></span>
                    <?php echo "<button class='button store_button' id='open-checkout' onclick='show_checkout(".$item['id'].")'>  <i class='bx bx-cart-alt store_icon'></i>  </button>  </div>";
                    }
                }
            }

            echo "</div><br><br><br><br><br>";
        }else{
            echo "<h2 class='section_subtitle' id='item'>SEARCHED ITEMS</h2>";
            echo "<span>Items not found</span>";
            echo "</div><br><br><br><br><br>";
        }
    }
    }
?>
</ul>