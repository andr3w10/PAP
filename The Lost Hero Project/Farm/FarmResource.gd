extends Node2D

var can_attack = false

export (String) var item_name = ""
export (String) var crop_path = ""

var item_type = ""

func _ready():
	var type = str(JsonData.item_data[item_name]["ItemType"])
	item_type = type
	MouseGrid.visible = true
	MouseGrid.validate = true
	MouseGrid.texture("24")

func plant_item():
	if Globals.map.farm.can_plant():
		Globals.map.farm.plant_crop(crop_path)
		PlayerInventory.decrease_item_quantity(1)
