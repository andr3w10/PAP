extends Node

#onready var player = Globals.player

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}

const valid_commands = [
	["set_speed", [ARG_FLOAT] ],
	["set_time", [ARG_INT] ],
	["give", [ARG_STRING, ARG_INT] ],
	["tp", [ARG_FLOAT, ARG_FLOAT] ],
	["spawn", [ARG_STRING, ARG_FLOAT, ARG_FLOAT] ],
	["set_time_speed", [ARG_FLOAT] ],
	["debug", [ARG_STRING] ]
]


var spawns = [
	#enemies
	["goblin", "res://Characters/Enemies/Goblin/Goblin.tscn"],
	["skeleton", "res://Characters/Enemies/Skeleton/Skeleton.tscn"],
	["mage", "res://Characters/Enemies/Mage/Mage.tscn"],
	#pets
	["fox", "res://Characters/Pets/Fox/Fox.tscn"],
	["cat", "res://Characters/Pets/Cat/Cat.tscn"],
	["falcon", "res://Characters/Pets/Falcon/Falcon.tscn"],
	["chameleon", "res://Characters/Pets/Chameleon/Chameleon.tscn"],
]


func set_speed(value):
	value = float(value)
	Globals.player.set_move_speed(value)
	return str('Successfully set speed to ', value)

func set_time(value):
	value = int(value)
	DateTime.time = value
	return str('Successfully set time to ', value)

func give(item, value):
	value = int(value)
	if JsonData.item_data.has(item):
		if item == "Coin":
			PlayerInventory.add_coins(value)
		elif item == "Wood":
			PlayerInventory.add_wood(value)
		elif item == "Brick":
			PlayerInventory.add_brick(value)
		else:
			PlayerInventory.add_item(item, value)
		return str('Successfully give ', item, ' (x', value, ')')
	else:
		return str('The item "', item, '" does not exist')

func tp(x, y):
	x = float(x)
	y = float(y)
	Globals.player.position = Vector2(x, y)
	return str('Successfully set position to x=', x, ' y=', y)

func spawn(spawn_name, x, y):
	for s in spawns:
		if s[0] == spawn_name:
			var character = load(s[1]).instance()
			Globals.map.add_character(character)
			character.position = Vector2(x, y)
			return str('Successfully spawn "', spawn_name, '" on x=', x, ' y=', y)
	#dont exists
	return str('The spawn "', spawn_name, '" does not exist')

func set_time_speed(value):
	value = float(value)
	DateTime.TIME_SPEED = value
	return str('Successfully set time speed to ', value)

func debug(value):
	value = str(value)
	if value == "true":
		Globals.show_debug = true
		
		return str('Successfully turned the debug_ui visibility to ', value)
	elif value == "false":
		Globals.show_debug = false
		
		return str('Successfully turned the debug_ui visibility to ', value)
	
	return str('The value ', value, ' does not exist')
