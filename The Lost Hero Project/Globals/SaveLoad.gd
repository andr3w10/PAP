extends Node

func save_game():
	var save_path = Globals.SAVE_DIR + "save" + str(Globals.current_story) + ".dat"
	var _chests_path = Globals.SAVE_DIR + "chests_save" + str(Globals.current_story) + ".dat"
	
	var data = {
	"player_name" : Globals.player_name,
	"account_type" : Globals.account_type,
	"account_username" : Globals.account_username,
	"player_initial_position" : Globals.player.global_position,
	"player_health" : PlayerStats.health ,
	"player_max_health" : PlayerStats.max_health ,
	"player_coins" : PlayerInventory.coins ,
	"player_wood" : PlayerInventory.wood ,
	"player_brick" : PlayerInventory.brick ,
	"player_inventory" : PlayerInventory.inventory ,
	"player_hotbar" : PlayerInventory.hotbar ,
	"spells" : PlayerInventory.spells ,
	"time" : DateTime.time,
	"current_location" : Globals.map.map_name ,
	"current_map_name" : Globals.map.map_path_name
	}
	save_data(data, save_path)
	
	save_chests_data()


func load_game():
	var save_path = Globals.SAVE_DIR + "save" + str(Globals.current_story) + ".dat"
	var chests_path = Globals.SAVE_DIR + "chests_save" + str(Globals.current_story) + ".dat"
	
	var data = load_data(save_path)
	
	Globals.player_name = data["player_name"]
	Globals.account_type = data["account_type"]
	Globals.account_username = data["account_username"]
	Globals.player_initial_position = data["player_initial_position"]
	PlayerStats.health = data["player_health"]
	PlayerStats.max_health = data["player_max_health"]
	PlayerInventory.coins = data["player_coins"]
	PlayerInventory.wood = data["player_wood"]
	PlayerInventory.brick = data["player_brick"]
	PlayerInventory.inventory = data["player_inventory"]
	PlayerInventory.hotbar = data["player_hotbar"]
	PlayerInventory.spells = data["spells"]
	DateTime.time = data["time"]
	
	if Globals.account_type == 1:
		HttpConnection.connect("coins_getted", self, "_on_coins_getted")
		HttpConnection._get_coins()
	
	data = load_data(chests_path)
	
	load_chests_data()

func save_data(data : Dictionary, save_data_path : String):
	var directory = Directory.new()
	if !directory.dir_exists(Globals.SAVE_DIR):
		directory.make_dir_recursive(Globals.SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_data_path, File.WRITE, Globals.password)
	if error == OK:
		file.store_var(data)
		file.close()

func load_data(data_path : String):
	var file = File.new()
	if file.file_exists(data_path):
		var error = file.open_encrypted_with_pass(data_path, File.READ, Globals.password)
		if error == OK:
			var data = file.get_var()
			file.close()
			return data
	return "Unexpected error!"

func save_chests_data():
	var chests_data : Dictionary
	
	chests_data = load_data(Globals.SAVE_DIR + "Chests/chests" + str(Globals.current_story) + ".dat")
	save_data(chests_data, Globals.SAVE_DIR + "chests_save" + str(Globals.current_story) + ".dat")

func load_chests_data():
	var chests_data : Dictionary
	
	chests_data = load_data(Globals.SAVE_DIR + "chests_save" + str(Globals.current_story) + ".dat")
	save_data(chests_data, Globals.SAVE_DIR + "Chests/chests" + str(Globals.current_story) + ".dat")

func start_new_game():
	DateTime.time = DateTime.INITIAL_TIME

	SaveLoad.save_game()

	SceneChanger.disconnect("scene_changed", self, "start_new_game")

	Globals.map.ui.right_display_box.start_tutorial()
	Globals.map.ui.right_display_box.tutorial_completed = false




func _on_coins_getted(coins):
	PlayerInventory.coins = coins
	HttpConnection.disconnect("coins_getted", self, "_on_coins_getted")
