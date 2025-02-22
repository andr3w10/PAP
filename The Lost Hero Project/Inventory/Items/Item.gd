extends Node2D

var item_name
var item_quantity
var item_path
var item_type

func sync_quantity(size):
	if size == 1:
		$Number.visible = false
		$StackBackground.visible = false
	else:
		$Number.visible = true
		$StackBackground.visible = true
		$Number.text = String(item_quantity)

func set_item(name, quantity):
	item_name = name
	item_quantity = quantity
	$ItemTexture.texture = load("res://PixelArt/Items/ItemsIcons/" + item_name + ".png")
	
	item_type = JsonData.item_data[item_name]["ItemType"]
	if item_type != "Resource":
		var stack_size = int(JsonData.item_data[item_name]["StackSize"])
		item_path = JsonData.item_data[item_name]["ItemPath"]
		sync_quantity(stack_size)
	else:
		sync_quantity(1)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	sync_quantity(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	sync_quantity(item_quantity)
