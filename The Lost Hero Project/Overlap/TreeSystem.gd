extends Node2D

enum Tiers {ONE, TWO, THREE}

onready var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var position_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var wood = preload("res://Inventory/Items/ItemDrops/Wood.tscn")
onready var apple = preload("res://Inventory/Items/ItemDrops/Berry.tscn")

export (Tiers) var tier = Tiers.ONE

export var max_life = 3

onready var life = max_life

#drop loot
func _on_Tree_drop_loot(drop_position):
	if tier == Tiers.ONE:
		drop_loot_tier_1(drop_position)
	
	if tier == Tiers.TWO:
		drop_loot_tier_2(drop_position)
	
	if tier == Tiers.THREE:
		drop_loot_tier_3(drop_position)

func drop_loot_tier_1(drop_position):
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(4, 8)):
		var wood_instance = wood.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", wood_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		wood_instance.global_position = Vector2(drop_position.x + item_position.x, drop_position.y + item_position.y)
	destroy_tree()


func drop_loot_tier_2(drop_position):
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(4, 8)):
		var wood_instance = wood.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", wood_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		wood_instance.global_position = Vector2(drop_position.x + item_position.x, drop_position.y + item_position.y)
		
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(2, 4)):
		var apple_instance = apple.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", apple_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		apple_instance.global_position = Vector2(drop_position.x + item_position.x, drop_position.y + item_position.y)
	destroy_tree()


func drop_loot_tier_3(drop_position):
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(4, 8)):
		var wood_instance = wood.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", wood_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		wood_instance.global_position = Vector2(drop_position.x + item_position.x, drop_position.y + item_position.y)
	destroy_tree()


#break the tree
func break_tree():
	_on_Tree_drop_loot(global_position)

func destroy_tree():
	get_parent().queue_free()

func _on_Tool_hit(area):
#	print(life)
	if(area.get_parent().get_parent().tool_type == "axe"):
		life -= 1
	if(life == 0):
		break_tree()
