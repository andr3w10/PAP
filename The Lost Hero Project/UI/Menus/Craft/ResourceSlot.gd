extends Panel

export (String) var ItemName = ''

var ItemClass = preload("res://Inventory/Items/Item.tscn")

var IsResource = true #is Wood, Brick and coin

var IsHotbar = false

var craft_menu

func menu_initialized():
	craft_menu = Globals.ui.menu_ui.menu_craft


func initialize_item(item_name, item_quantity):
	var item = get_node_or_null("Item")
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)


func remove_from_inventory():
	match ItemName:
		"Wood":
			PlayerInventory.wood -=1
		"Brick":
			PlayerInventory.brick -=1
		"Coin":
			PlayerInventory.coins -=1
	
	craft_menu.update_inventory()


func add_to_inventory():
	match ItemName:
		"Wood":
			PlayerInventory.wood +=1
		"Brick":
			PlayerInventory.brick +=1
		"Coin":
			PlayerInventory.coins +=1
	
	craft_menu.update_inventory()


func _on_Button_pressed():
	var quantity = 0
	match ItemName:
		"Wood":
			quantity = PlayerInventory.wood
		"Brick":
			quantity = PlayerInventory.brick
		"Coin":
			quantity = PlayerInventory.coins
	if quantity > 0:
		var craft_slots = craft_menu.craft_slots

		var slots_count = 0
		for slot in craft_slots.get_children():
			var item = slot.get_node_or_null("Item")
			if item != null:
				slots_count += 1
		if slots_count < craft_menu.MAX_CRAFT_SLOTS: #Check if can add another item to the mix
			remove_from_inventory()
		craft_menu.add_to_craft_slots(ItemName, IsHotbar, IsResource)

