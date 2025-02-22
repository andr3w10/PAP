extends Node2D

var can_attack = false

export var item_name = ""
var item_type = ""

func _ready():
	var type = str(JsonData.item_data[item_name]["ItemType"])
	item_type = type
	MouseGrid.visible = false

func consume_item(quantity_to_consume):
	if PlayerStats.health < PlayerStats.max_health:
		PlayerInventory.decrease_item_quantity(quantity_to_consume)
		var health_amount = int(JsonData.item_data[item_name]["AddHealth"])
		PlayerStats.set_health(PlayerStats.health + health_amount)
