extends Panel

var ItemClass = preload("res://Inventory/Items/Item.tscn")


var ItemName = ''
var ItemId = '' #in inventory
var OnCraftSlot = false

var IsResource = false #is Wood, Brick and coin

export (bool) var IsHotbar = false

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
	if !IsHotbar:
		if PlayerInventory.inventory[ItemId][1] > 1:
			PlayerInventory.inventory[ItemId][1] -= 1
		else:
			PlayerInventory.inventory[ItemId][1] -= 1
			var curr_item = get_node_or_null("Item")
			if curr_item != null:
				curr_item.queue_free()
				
	else:
		if PlayerInventory.hotbar[ItemId][1] > 1:
			PlayerInventory.hotbar[ItemId][1] -= 1
		else:
			PlayerInventory.hotbar[ItemId][1] -= 1
			var curr_item = get_node_or_null("Item")
			if curr_item != null:
				curr_item.queue_free()
	
	craft_menu.update_inventory()


func add_to_inventory():
	if !IsResource:
		if !IsHotbar:			
			if PlayerInventory.inventory.has(ItemId) && PlayerInventory.inventory[ItemId][1] > 0:
				PlayerInventory.inventory[ItemId][1] += 1
			else:#is not in inventory yet
				var slots = craft_menu.inventory_slots.get_children()
				for i in range(slots.size()):
					if PlayerInventory.inventory.has(i):
						if PlayerInventory.inventory[i][0] == ItemName:
							craft_menu.inventory_empty_slots.erase(i)
				
				PlayerInventory.inventory[ItemId][1] = 1
		else:
			if PlayerInventory.hotbar.has(ItemId):
				PlayerInventory.hotbar[ItemId][1] += 1
			else:#is not in hotbar yet
				var slots = craft_menu.hotbar_slots.get_children()
				for i in range(slots.size()):
					if PlayerInventory.hotbar.has(i):
						if PlayerInventory.hotbar[i][0] == ItemName:
							craft_menu.hotbar_empty_slots.erase(i)
				
				PlayerInventory.hotbar[ItemId][1] = 1
	else:
		match ItemName:
			"Wood":
				PlayerInventory.wood +=1
			"Brick":
				PlayerInventory.brick +=1
			"Coin":
				PlayerInventory.coins +=1
	
	craft_menu.update_inventory()
	
	var curr_item = self.get_node_or_null("Item")
	if curr_item != null:
		curr_item.queue_free()
	ItemName = ''
	ItemId = ''

func _on_Button_pressed():
	var curr_item = get_node_or_null("Item")
	if curr_item != null:
		var craft_slots = craft_menu.craft_slots
		
		if OnCraftSlot:
			add_to_inventory()
		else:
			var slots_count = 0
			for slot in craft_slots.get_children():
				var item = slot.get_node_or_null("Item")
				if item != null:
					slots_count += 1
			if slots_count < craft_menu.MAX_CRAFT_SLOTS: #Check if can add another item to the mix
				remove_from_inventory()
			craft_menu.add_to_craft_slots(ItemId, IsHotbar, IsResource)
