extends Node2D

enum Tiers {ONE, TWO, THREE, BOSS}

onready var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var position_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
onready var coin = preload("res://Inventory/Items/ItemDrops/Coin.tscn")

export (Tiers) var tier = Tiers.ONE

func _on_Enemy_drop_loot():
	var spawn_position = global_position
	if tier == Tiers.ONE:
		drop_loot_tier_1(spawn_position)
	if tier == Tiers.BOSS:
		drop_loot_tier_boss(spawn_position)

func drop_loot_tier_1(spawn_position):
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(3, 4)):
		var coin_instance = coin.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", coin_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		coin_instance.global_position = Vector2(spawn_position.x + item_position.x, spawn_position.y + item_position.y)

func drop_loot_tier_boss(spawn_position):
	loot_randomizer.randomize()
	position_randomizer.randomize()
	for _i in range(loot_randomizer.randi_range(15, 20)):
		var coin_instance = coin.instance()
		Globals.map.get_node("World/ItemsDrop").call_deferred("add_child", coin_instance)
		var item_position = Vector2(position_randomizer.randf_range(-20, 20), position_randomizer.randf_range(-20, 20))
		coin_instance.global_position = Vector2(spawn_position.x + item_position.x, spawn_position.y + item_position.y)
