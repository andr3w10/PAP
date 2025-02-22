extends Control

onready var ok_btn = $Ok
onready var delete_btn = $Delete

onready var group = get_node("1").group

var active_profiles = 0

func _on_Delete_button_up():
	var pressed_btn = group.get_pressed_button().name
	match pressed_btn:
		"1":
			delete_data(1)
		"2":
			delete_data(2)
		"3":
			delete_data(3)

func _on_Ok_button_up():
	var pressed_btn = group.get_pressed_button().name
	match pressed_btn:
		"1":
			load_data(1)
		"2":
			load_data(2)
		"3":
			load_data(3)

func turn_on_btns():
	ok_btn.disabled = false
	delete_btn.disabled= false

func turn_off_btns():
	ok_btn.disabled = true
	delete_btn.disabled= true

func delete_data(save_num : int):
	#data file
	var data_path = Globals.SAVE_DIR + "save" + str(save_num) + ".dat"
	
	var file = File.new()
	if file.file_exists(data_path):
		var error = file.open_encrypted_with_pass(data_path, File.READ, Globals.password)
		if error == OK:
			var data = file.get_var()
			file.close()
			if data["account_type"] == 1:
				var username = data["account_username"]
				HttpConnection._logged_out_game(username)
	
	var data_file = File.new()
	if data_file.file_exists(data_path):
		var data_dir = Directory.new()
		data_dir.remove(data_path)
	#chest saves
	var chest_path = Globals.SAVE_DIR + "chests_save" + str(save_num) + ".dat"
	var chest_file = File.new()
	if chest_file.file_exists(chest_path):
		var chest_dir = Directory.new()
		chest_dir.remove(chest_path)
	#update textures
	get_parent().check_stories_texture()
	
	for i in group.get_buttons():
		i.pressed = false
	
	check_active_profiles()
	
	get_parent().get_node("Display").get_node(str(save_num) + "/account_type").texture = null

func load_data(save_num : int):
	var data_path = Globals.SAVE_DIR + "save" + str(save_num) + ".dat"
	var file = File.new()
	if file.file_exists(data_path):
		var error = file.open_encrypted_with_pass(data_path, File.READ, Globals.password)
		if error == OK:
			var data = file.get_var()
			file.close()
			Globals.current_story = save_num
			SceneChanger.change_the_scene("res://Scenes/Levels/" + data["current_map_name"] + ".tscn", 0, true)
			var _value = SceneChanger.connect("faded_in", SaveLoad, "load_game")
	
	for i in group.get_buttons():
		i.pressed = false
	
	check_active_profiles()

func check_active_profiles():
	if group.get_pressed_button() == null:
		turn_off_btns()
	else:
		turn_on_btns()

func _on_1_button_up():
	check_active_profiles()

func _on_2_button_up():
	check_active_profiles()

func _on_3_button_up():
	check_active_profiles()
