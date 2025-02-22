extends Node

signal login_checked
signal items_getted
signal coins_getted

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://192.168.1.65/tlh_website/php/godot_connection.php" #path to php page
#const SERVER_URL = "http://localhost/tlh_website/php/godot_connection.php" #path to php page
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false

var items = []

func _ready():
	# Connect our request handler:
	add_child(http_request)
	var _value = http_request.connect("request_completed", self, "_http_request_completed")

func _process(_delta):
	# Check if we are good to send a request:
	if is_requesting:
		return
		
	if request_queue.empty():
		return
		
	is_requesting = true
	_send_request(request_queue.pop_front())

func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	#if have connection errors
	if _result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
		
	var response_body = _body.get_string_from_utf8()
	# Grab our JSON and handle any errors reported by our PHP code:
	var response = parse_json(response_body)
	
	if response['error'] != "none":
		printerr("We returned error: " + response['error'])
		return
		
	#we handle all other requests here:
#	print("Response Body:\n" + response_body)
	
	
	#============ GET ITEMS =====================================
	if response['command'] == "get_items":
		items = []
		for purchase in response['response']:
			if purchase != 'size':
				for _i in range(response['response'][purchase]['item_quantity']):
					add_item(response['response'][purchase]['name'], response['response'][purchase]['pack_quantity'])
				
				_delete_to_claim(response['response'][purchase]['id'])
		
		emit_signal("items_getted", items)
	
	
	
	#============ CHECK LOGIN =====================================
	if response['command'] == "check_login":
		var cont = 0
		var login : bool = false
		for user in response['response']:
			if user != 'size':
				var logged = response['response'][user]['logged_in_game']
				if logged == '0':
					cont += 1
		if cont > 0:
			login = true
		else:
			login = false
	
		emit_signal("login_checked", login)
	
	
	#============ GET COINS =====================================
	if response['command'] == "get_coins":
		var coins = 0
		for user in response['response']:
			if user != 'size':
				coins = int(response['response'][user]['coins'])
		
		emit_signal("coins_getted", coins)
	
	
	

func _send_request(request : Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, false, HTTPClient.METHOD_POST, body) #false or true -> (http: false) / (https: true)
	
	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
	
	# Print out request for debugging:
#	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)

func _update_coins():
	var username = Globals.account_username
	var coins = PlayerInventory.coins
	
	var command = "update_coins"
	var data = {"username" : username, "coins": coins}
	request_queue.push_back({"command" : command, "data" : data})

func _get_coins():
	var username = Globals.account_username
	
	var command = "get_coins"
	var data = {"username" : username}
	request_queue.push_back({"command" : command, "data" : data})

func _get_items(username):
	var command = "get_items"
	var data = {"username" : username}
	request_queue.push_back({"command" : command, "data" : data});

func _delete_to_claim(id):
	var command = "delete_to_claim"
	var data = {"id" : id}
	request_queue.push_back({"command" : command, "data" : data});

func _check_login(username, password):
	var command = "check_login"
	var data = {"password" : password, "username" : username}
	request_queue.push_back({"command" : command, "data" : data});

func _logged_in_game(username):
	var command = "logged_in_game"
	var data = {"username" : username}
	request_queue.push_back({"command" : command, "data" : data});

func _logged_out_game(username):
	var command = "logged_out_game"
	var data = {"username" : username}
	request_queue.push_back({"command" : command, "data" : data});


func add_item(str_name, quantity):
	for _j in range(quantity):
		var formated_name = ""
		
		for i in str_name:
			if i != " ":
				formated_name += i
		
		items.append(formated_name)

func show_items():
	$items.text = ""
	for item in items:
		$items.text += item
		$items.text += "\n"
