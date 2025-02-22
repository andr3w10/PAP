extends Control

onready var animation_player = get_parent().get_parent().get_parent().get_node("AnimationPlayer")

onready var main = $Display

onready var new_story_1 = $new_story_btn1
onready var new_story_2 = $new_story_btn2
onready var new_story_3 = $new_story_btn3

var is_starting_story = false

var temp_account_type = null

func _ready():
	check_stories_texture()

func _input(event):
	#tests and temp
	if event.is_action_pressed("ui_cancel") && is_starting_story == false && temp_account_type == null:
		animation_player.play("left_mid")
	if event.is_action_pressed("ui_accept") && is_starting_story == true && Globals.account_type != null:
		Globals.player_name = get_node("NameInsert/LineEdit").text
		save_and_start()

#NEW STORY BUTTONS
func _on_new_story_btn1_button_up():
	Globals.current_story = 1
	start_story()

func _on_new_story_btn2_button_up():
	Globals.current_story = 2
	start_story()

func _on_new_story_btn3_button_up():
	Globals.current_story = 3
	start_story()

func check_stories_texture():
	for i in Globals.MAX_SAVES:
		var path = Globals.SAVE_DIR + "save" + str(i + 1) + ".dat"
		var file = File.new()
		if file.file_exists(path):
			match i:
				0:#1
					new_story_1.visible = false
					update_label_data(1)
				1:#2
					new_story_2.visible = false
					update_label_data(2)
				2:#3
					new_story_3.visible = false
					update_label_data(3)
		else:
			match i:
				0:#1
					new_story_1.visible = true
				1:#2
					new_story_2.visible = true
				2:#3
					new_story_3.visible = true

func start_story():
	is_starting_story = true
	animation_player.play("show_account_type")

func save_and_start():
	if Globals.account_type == 1:
		HttpConnection._logged_in_game(Globals.account_username)
	
	SceneChanger.change_the_scene("res://Scenes/Levels/" + Globals.START_SCENE_PATH_NAME + ".tscn")
	var _value = SceneChanger.connect("scene_changed", SaveLoad, "start_new_game")

func update_label_data(num : int):
	var data = get_saved_data(num)
	
	main.get_node(str(num) + "/Name").text = str(data["player_name"])
	main.get_node(str(num) + "/Gold").text = str(data["player_coins"])
	main.get_node(str(num) + "/Time").text = get_time(data["time"])
	main.get_node(str(num) + "/Location").text = str(data["current_location"])
	if data["account_type"] == 1: #online
		main.get_node(str(num) + "/account_type").texture = load("res://Title/Buttons/START/online.png")
	else: #offline
		main.get_node(str(num) + "/account_type").texture = load("res://Title/Buttons/START/offline.png")

func get_saved_data(save_num : int):
	var data_path = Globals.SAVE_DIR + "save" + str(save_num) + ".dat"
	var file = File.new()
	if file.file_exists(data_path):
		var error = file.open_encrypted_with_pass(data_path, File.READ, Globals.password)
		if error == OK:
			var data = file.get_var()
			file.close()
			return data
	return "Unexpected error!"

func get_time(time):
	var minute = 0
	var hour = 0
	var day = 0
	var year = 0
	
	var int_time = int(floor(time))
	
	minute = (int_time / 60) % 60
	hour = (int_time / (60 * 60)) % 24
	day = (int_time / (60 * 60 * 24)) % 365
	year = (int_time / (60 * 60 * 24 * 365))
	
	var text = str(year) + "y " + str(day) + "d " + str(hour) + ":" + str(minute)
	
	return text


func _on_online_pressed():
	temp_account_type = 1
	animation_player.play("hide_account_type")
	yield(animation_player, "animation_finished")
	get_node("LoginPage/errors").visible = false
	get_node("LoginPage/username").text = ""
	get_node("LoginPage/password").text = ""
	animation_player.play("show_login")


func _on_offline_pressed():
	Globals.account_type = 0
	animation_player.play("hide_account_type")
	yield(animation_player, "animation_finished")
	animation_player.play("show_name_insert")


func _on_LoginBtn_pressed():
	var username = get_node("LoginPage/username").text
	var password = get_node("LoginPage/password").text
	
	var _value = HttpConnection.connect("login_checked", self, "_login_ckecked")
	HttpConnection._check_login(username, password)

func _on_close_pressed():
	if animation_player.is_playing():
		yield(animation_player, "animation_finished")
	animation_player.play("hide_login")

func _login_ckecked(login):
	HttpConnection.disconnect("login_checked", self, "_login_ckecked")
	
	var username = get_node("LoginPage/username").text
	
	if login:
		Globals.account_type = 1
		Globals.account_username = username
		Globals.player_name = username
		animation_player.play("hide_login")
		yield(animation_player, "animation_finished")
		animation_player.play("show_name_insert")
	else:
		get_node("LoginPage/errors").visible = true


func _update_name_insert():
	get_node("NameInsert/LineEdit").text = Globals.player_name


func _on_register_pressed():
	var _value = OS.shell_open("http://192.168.1.65/tlh_website/html/login.php")
#	var _value = OS.shell_open("http://localhost/tlh_website/html/login.php")
