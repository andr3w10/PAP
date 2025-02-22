<?php
	function print_response($dictionary = [], $error = "none"){
		$string = "";
		
		# Convert our dictionary into a JSON string:
		$string = "{\"error\" : \"$error\",
					\"command\" : \"$_REQUEST[command]\",
					\"response\" : ". json_encode($dictionary) ."}";
		
		# Print out our json to Godot!
		echo $string;
	}

	# Make sure our command is sent properly:
	if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){
		#print_response([], "missing_command");
		echo "{\"error\" : \"missing_command\", \"response\" : {}}";
		die;
	}
	
	# Make sure our data is sent, even if empty:
	if (!isset($_REQUEST['data']) or $_REQUEST['data'] === null){
		print_response([], "missing_data");
		die;
	}


	# Set connection properties for our database  --> LOCALHOST:
	$sql_host = "localhost";	# Where our database is located
	$sql_db = "tlh_database";			# Name of our database
	$sql_username = "root";		# Login username for our database
	$sql_password = "";			# Login password for our database

    # Set connection properties for our database  --> HOST:
	#$sql_host = "sql300.epizy.com";	# Where our database is located
	#$sql_db = "epiz_30578554_tlh_database";			# Name of our database
	#$sql_username = "epiz_30578554";		# Login username for our database
	#$sql_password = "bvVd36RzY5iypTO";			# Login password for our database

	# Set up our data in a format that PDO understands:
	$dsn = "mysql:dbname=$sql_db;host=$sql_host;charset=utf8mb4;port=3306";
	$pdo = null;
	
	# Attempt to connect:
	try{
		$pdo = new PDO($dsn, $sql_username, $sql_password);
	}
	
	# If something went wrong, return an error to Godot:
	catch (\PDOException $e){
		print_response([], "db_login_error");
		die;
	}

	# Convert our Godot json string into a dictionary:
	$json = json_decode($_REQUEST['data'], true);
	
	# Check that the json was valid:
	if ($json === null){
		print_response([], "invalid_json");
		die;
	}

	# Execute our Godot commands:
	switch ($_REQUEST['command']){
		# Fetch a number of scores from our table:
		case "get_items":
			# Check if Godot set some preferences and adjust accordingly:
			#if (isset($json['password']))
			#	$password = $json['password'];
				
			if (isset($json['username']))
				$username = $json['username'];
				
			# Form our SQL request template:
			$template = "SELECT purchases.id, purchases.item_quantity, purchases.spent_coins, purchases.purchase_date, store.name, store.price, store.pack_quantity, store.type, store.release_date, store.is_exclusive from purchases inner join store on purchases.item_id = store.id where purchases.username = :username and purchases.id = (select to_claim.purchase_id from to_claim where to_claim.purchase_id = purchases.id) and purchases.username = (SELECT users.username from users where users.username = :username)";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			#$sth -> bindValue("password", $password, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);

			print_response($data);
		
			die;
		break;

		case "delete_to_claim":	
			# Check if Godot set some preferences and adjust accordingly:
			if (isset($json['id']))
				$id = $json['id'];

			# Form our SQL request template:
			$template = "DELETE FROM to_claim WHERE purchase_id = $id";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);

			print_response($data);
		
			die;
		break;

		case "get_coins":
			# Check if Godot set some preferences and adjust accordingly:
			#if (isset($json['password']))
			#	$password = $json['password'];
				
			if (isset($json['username']))
				$username = $json['username'];
				
			# Form our SQL request template:
			$template = "SELECT coins from users where username = :username";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			#$sth -> bindValue("password", $password, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);
			
			print_response($data);
		
			die;
		break;

		case "update_coins":
			# Check if Godot set some preferences and adjust accordingly:
			#if (isset($json['password']))
			#	$password = $json['password'];
				
			if (isset($json['username']))
				$username = $json['username'];

			if (isset($json['coins']))
				$coins = $json['coins'];
				
			# Form our SQL request template:
			$template = "UPDATE users set coins = $coins where username = :username";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			#$sth -> bindValue("password", $password, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);
			
			print_response($data);
		
			die;
		break;

		case "check_login":
			# Check if Godot set some preferences and adjust accordingly:
			if (isset($json['password']))
				$password = $json['password'];
				
				
			if (isset($json['username']))
				$username = $json['username'];
				
			# Form our SQL request template:
			$template = "SELECT password from users where username = :username";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);

			if(password_verify($password, $data[0]['password']))
			{
				$template = "SELECT * from users where username = :username";
				$sth = $pdo -> prepare($template);
				$sth -> bindValue("username", $username, PDO::PARAM_STR);
				$sth -> execute();

				$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			}else{
				$template = "SELECT * from users where username = :username and password = :password";
				$sth = $pdo -> prepare($template);
				$sth -> bindValue("username", $username, PDO::PARAM_STR);
				$sth -> bindValue("password", $password, PDO::PARAM_STR);
				$sth -> execute();

				$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			}
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);
			
			print_response($data);
		
			die;
		break;


		case "logged_in_game":
			# Check if Godot set some preferences and adjust accordingly:
			#if (isset($json['password']))
			#	$password = $json['password'];
				
			if (isset($json['username']))
				$username = $json['username'];
				
			# Form our SQL request template:
			$template = "UPDATE users set logged_in_game = true where username = :username";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			#$sth -> bindValue("password", $password, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);
			
			print_response($data);
		
			die;
		break;

		case "logged_out_game":
			# Check if Godot set some preferences and adjust accordingly:
			#if (isset($json['password']))
			#	$password = $json['password'];
				
			if (isset($json['username']))
				$username = $json['username'];
				
			# Form our SQL request template:
			$template = "UPDATE users set logged_in_game = false where username = :username";
			
			# Prepare and send the actual request to the database:
			$sth = $pdo -> prepare($template);
			$sth -> bindValue("username", $username, PDO::PARAM_STR);
			#$sth -> bindValue("password", $password, PDO::PARAM_STR);
			$sth -> execute();
			
			# Grab all the resulting data from our request:
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			# Add the size of our result to the Godot structure:
			$data["size"] = sizeof($data);
			
			print_response($data);
		
			die;
		break;


	
		# Handle invalid requests:
		default:
			print_response([], "invalid_command");
			die;
		break;
	
	}
?>