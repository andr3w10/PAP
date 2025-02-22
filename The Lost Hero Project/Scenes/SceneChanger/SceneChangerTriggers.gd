tool

extends Area2D

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}

const valid_restrictions = [
	["element", [ARG_STRING] ],
	["coins", [ARG_INT] ],
	["item", [ARG_STRING] ],
]

const FIRST_MAP_SAVE = "res://Scenes/Levels/"

export(String) var next_scene_path_name = ""
export(float) var delay = 0
export(Vector2) var player_next_scene_spawn_position = Vector2.ZERO

export (Array, String) var restrictions = []

func _ready():
	get_parent().visible = false

func show():
	get_parent().visible = true
	

func get_configuration_warning() -> String:
	if next_scene_path_name == "":
		return "next_scene_path must be must be set"
	else:
		return ""

func _on_SceneChangerTrigger_body_entered(body):
	if check_restrictions(): #if all the requesits are completed
	#	temp_save_map()
	#	var map_path = Globals.SAVE_DIR + "Map/temp/" + next_scene_path_name + str(Globals.current_story) + ".tscn"
		var next_scene_path = ""
	#	var file = File.new()
	#	if file.file_exists(map_path):
	#		print("new")
	#		next_scene_path = map_path
	#	else:
	#		print("default")
		next_scene_path = FIRST_MAP_SAVE + next_scene_path_name + ".tscn"
		
		Globals.player_initial_position = player_next_scene_spawn_position
		SceneChanger.change_the_scene(next_scene_path, delay)
	else:
		var velocity = body.velocity
		var body_position = body.global_position
		
		var module_velocity = velocity
		if module_velocity.x < 0:
			module_velocity.x = module_velocity.x * -1
		if module_velocity.y < 0:
			module_velocity.y = module_velocity.y * -1
		
		if module_velocity.x > module_velocity.y:
			if velocity.x > 0: # >
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x - (24 * 2), body_position.y)
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
			elif velocity.x < 0: # <
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x + (24 * 2), body_position.y)
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
		
		elif module_velocity.x < module_velocity.y:
			if velocity.y > 0: # \/
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x, body_position.y - (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
			elif velocity.y < 0: # /\
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x, body_position.y + (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
		
		elif int(module_velocity.x) == int(module_velocity.y):
			if velocity.x > 0 && velocity.y > 0: # \>
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x - (24 * 2), body_position.y - (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
			elif velocity.x < 0 && velocity.y > 0: # </
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x + (24 * 2), body_position.y - (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
			elif velocity.x > 0 && velocity.y < 0: # />
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x - (24 * 2), body_position.y + (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
			if velocity.x < 0 && velocity.y < 0: # <\
				get_tree().paused = false
				body.can_move = false
				body.target_pos = Vector2(body_position.x + (24 * 2), body_position.y + (24 * 2))
				body.is_moving_towards = true
				yield(get_tree().create_timer(0.25), "timeout")
				body.is_moving_towards = false
				body.target_pos = null
				body.can_move = true
				get_tree().paused = true
		

##canceld
#func temp_save_map():
#	var directory = Directory.new()
#	if !directory.dir_exists(Globals.SAVE_DIR + "Map/temp/"):
#		directory.make_dir_recursive(Globals.SAVE_DIR + "Map/temp/")
#
#	var map_save_path = Globals.SAVE_DIR + "Map/temp/" + str(Globals.map.map_path_name) + str(Globals.current_story) + ".tscn"
#
#	var map = Globals.map.get_map_changes()
#
#	ResourceSaver.save(map_save_path, map)


func check_restrictions():
	if restrictions == []:
		return true
	else:
		for restriction in restrictions:
			var words = restriction.split(" ")
			words = Array(words)
			
			for _i in range(words.count("")):
				words.erase("")
			
			if words.size() == 0:
				return
			
			var restriction_word = words.pop_front()
			var can_pass = true
			
			for r in valid_restrictions:
				if r[0] == restriction_word:
					if words.size() != r[1].size():
						#error in num of params
						print(str('Failure executing restriction "', restriction_word, '", expected ', r[1].size(), ' parameters'))
						return
					for i in range(words.size()):
						if not check_type(words[i], r[1][i]):
							#error in parameter type
							print(str('Failure executing restriction "', restriction_word, ', parameter ', (i+1), ' ("', words[i], '") is of the wrong type'))
							return
					#the text is correct
					if !output_text(callv(restriction_word, words)):
						can_pass = false
			
			if can_pass:
				return true
			else:
				return false
			
			#dont exists
#			print(str('Restriction "', restriction_word, '" does not exist'))

func check_type(string, type):
	if type == ARG_INT:
		return string.is_valid_integer()
	if type == ARG_FLOAT:
		return string.is_valid_float()
	if type == ARG_STRING:
		return true
	if type == ARG_BOOL:
		return (string == "true" or string == "false")
	return false


func output_text(text):
	if text != null && text != "null":
		Globals.ui.dialogue_manager.init_premade_message(text)
		return false #cant
	elif text == "null":
		return true #have all requesits


#RESTRICTIONS FUNCS
func element(element):
	var element_exists = false
	for e in PlayerInventory.spells:
		var element_name = PlayerInventory.spells[e][0]
		if element_name == element:
			element_exists = true
			if PlayerInventory.spells[e][1] == 0:
				return str('To continue this path, you need to unlock the ', element ,' Element...')
	if !element_exists:
		print(str('Failure executing restriction "element", element name does not exist!'))
		return
	return "null"

func coins(_num):
	pass

func item(_item_name):
	pass
