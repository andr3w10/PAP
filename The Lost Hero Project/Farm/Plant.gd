extends Area2D

var farm_map

var CONSTANTS = preload("res://Farm/FARM_CONSTANTS.gd")

onready var collision = $CollisionShape2D
onready var animation_player = $AnimationPlayer

onready var drop_position = $Position2D

onready var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var position_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()

var type = 1
var object_name = ""
var current_phase = 0 #its a seed
var day_of_current_phase = 0
var crop_age = 0
var dead = false

export (Array, String) var drop_path = []
export (Vector2) var items_drop_range = Vector2.ZERO

func initialize(data):
	type = data.get("type")
	object_name = data.get("object_name")
	current_phase = data.get("current_phase")
	day_of_current_phase = data.get("day_of_current_phase")
	crop_age = data.get("crop_age")

func check_plant_status(phase_days):
	var required_days = phase_days[current_phase]
	if day_of_current_phase == required_days:
		current_phase += 1
		day_of_current_phase = 0
	
	var anim = str(current_phase)
	if current_phase == 0:
		collision.disabled = true
	elif current_phase == len(phase_days) - 1:
		collision.disabled = false
	else:
		collision.disabled = true
	
	animation_player.play(anim)


func _on_Tool_hit(area):
	if(area.get_parent().get_parent().tool_type == "hoe"):
		loot_randomizer.randomize()
		position_randomizer.randomize()
		for num in range(drop_path.size()):
			for _i in range(loot_randomizer.randi_range(items_drop_range.x, items_drop_range.y)):
				var drop_instance = load(drop_path[num]).instance()
				Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", drop_instance)
				var item_position = Vector2(position_randomizer.randf_range(-12, 12), position_randomizer.randf_range(-12, 12))
				drop_instance.global_position = Vector2(drop_position.global_position.x + item_position.x, drop_position.global_position.y + item_position.y)
		
		Globals.map.farm.clear_dirt(self.global_position)
		queue_free()
