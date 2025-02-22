<?php

function check_login($con, $required)
{

	if(isset($_SESSION['username']))
	{

		$id = $_SESSION['username'];
		$query = "select * from users where username = '$id' limit 1";

		$result = mysqli_query($con,$query);
		if($result && mysqli_num_rows($result) > 0)
		{
			$user_data = mysqli_fetch_assoc($result);
			return $user_data;
		}
	}
	if ($required){
		header("Location: ../html/login.php");
	}
	return null;
}


function get_new_price($old_price){
	if(isset($_SESSION['discount_code']) && isset($_SESSION['discount_amount'])){
		$temp = ($_SESSION['discount_amount'])/100;
		$temp = 1 - $temp;
		$new_price = ceil($old_price * $temp);
		return $new_price;
	}else{
		return $old_price;
	}
}


?>