extends Node

const password = "thelosthero"
const SAVE_DIR = "user://Saves/Chests/"

var chests_initial_items = {#slot_index: [item_name (index 0), item_quantity (index 1)]
	"000":{
		0: ["BasicSword", 1],
		1: ["MagicStick", 1],
	},
	"001":{
		0: ["Bow", 1],
	},
	"002":{
		0: ["Berry", 2],
		1: ["Chicken", 1],
		2: ["Bread", 4],
	},
}

func _ready():
	for i in Globals.MAX_SAVES:
		var save_path = SAVE_DIR + "chests" + str(i + 1) + ".dat"
		
		var directory = Directory.new()
		if !directory.dir_exists(SAVE_DIR):
			directory.make_dir_recursive(SAVE_DIR)
		
		var file = File.new()
		var error = file.open_encrypted_with_pass(save_path, File.WRITE, password)
		if error == OK:
			file.store_var(chests_initial_items)
			file.close()
