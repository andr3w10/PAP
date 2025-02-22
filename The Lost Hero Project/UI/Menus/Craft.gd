extends Control

const MAX_CRAFT_SLOTS = 5

const RECIPES_PATH = "res://UI/Menus/Craft/ItemRecipes.json"

onready var inventory_slots = $Inventory/RInventorySlots
onready var hotbar_slots = $Inventory/LInventorySlots/HotbarSlots
onready var wood_slot = $Inventory/LInventorySlots/WoodUI
onready var brick_slot = $Inventory/LInventorySlots/BrickUI
onready var coins_slot = $Inventory/LInventorySlots/CoinsUI
onready var craft_slots = $CraftSlots

var hashed_recipes = []

var inventory_empty_slots = []
var hotbar_empty_slots = []

#var ItemClass = preload("res://Inventory/Items/Item.tscn")

func _ready():
	var _value = get_parent().connect("page_changed", self, "on_close_craft_menu")

func _input(event):
	if event.is_action_pressed("menu"):
		on_close_craft_menu()

func initialize_craft_menu():	
#	reset_ui()
	
	for slot in inventory_slots.get_children():
		var item = slot.get_node_or_null("Item")
		if item != null:
			item.queue_free()
	for slot in hotbar_slots.get_children():
		var item = slot.get_node_or_null("Item")
		if item != null:
			item.queue_free()
	
	yield(get_tree().create_timer(0.01), "timeout")
	
	hash_recipes()
	load_inventory()
	
	get_tree().call_group("Slots", "menu_initialized")

#func reset_ui():
#	clear_inventory()
#	clear_craft_slots()

func hash_recipes():
	var recipes = get_recipes()
	
	for recipe in recipes:
		var new_recipe = recipe.duplicate() #Create a new subarray to preserve the orignal 
		new_recipe.pop_front() #Remove the first element (the resulting item)
		new_recipe.sort() #Sort it alphabetically
		hashed_recipes.append(new_recipe.hash()) #Hash the resulting array and add it to the hastable (the hashed_recipes array)

func load_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			if PlayerInventory.inventory[i][1] != 0:
				slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
				slots[i].ItemName = PlayerInventory.inventory[i][0]
				slots[i].ItemId = i
	#			var item = ItemClass.instance()
	#			slots[i].add_child(item)
	#			slots[i].ItemId = i
	#			slots[i].ItemName = PlayerInventory.inventory[i][0]
	#			item.set_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			else:
				inventory_empty_slots.append(i)
	
	slots = hotbar_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			if PlayerInventory.hotbar[i][1] != 0:
				slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
				slots[i].ItemName = PlayerInventory.hotbar[i][0]
				slots[i].ItemId = i
	#			var item = ItemClass.instance()
	#			slots[i].add_child(item)
	#			slots[i].ItemId = i
	#			slots[i].ItemName = PlayerInventory.inventory[i][0]
	#			item.set_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			else:
				hotbar_empty_slots.append(i)
	
	wood_slot.get_node("WoodNum").text = str(PlayerInventory.wood)
	brick_slot.get_node("BrickNum").text = str(PlayerInventory.brick)
	coins_slot.get_node("CoinsNum").text = str(PlayerInventory.coins)

func update_inventory():
#	clear_inventory()

#	var cont = 0
#	for slot in craft_slots.get_children():
#		var item = slot.get_node_or_null("Item")
#		if item == null:
#			cont += 1
#	if cont == MAX_CRAFT_SLOTS:
#		inventory_empty_slots = []
#		hotbar_empty_slots = []
	
	load_inventory()

#func clear_inventory():
#	PlayerInventory.inventory = {}
#	for slot in inventory_slots.get_children():
#		var item = slot.get_node_or_null("Item")
#		if item != null:
#			item.queue_free()
#			slot.ItemId = ''
#			slot.ItemName = ''
#
#	for slot in hotbar_slots.get_children():
#		var item = slot.get_node_or_null("Item")
#		if item != null:
#			item.queue_free()
#			slot.ItemId = ''
#			slot.ItemName = ''
#
#	wood_slot.get_node("WoodNum").text = "0"
#	brick_slot.get_node("BrickNum").text = "0"
#
#	emit_signal("inventory_cleared")

func on_close_craft_menu():
	inventory_empty_slots = []
	hotbar_empty_slots = []
	
	for slot in craft_slots.get_children():
		var item = slot.get_node_or_null("Item")
		if item != null:
			slot.add_to_inventory()
			item.queue_free()

func clear_craft_slots():
	for slot in craft_slots.get_children():
		var item = slot.get_node_or_null("Item")
		if item != null:
			item.queue_free()

func add_to_craft_slots(id, isHotbar, isResource):
	var slots_count = 0
	for slot in craft_slots.get_children():
		var item = slot.get_node_or_null("Item")
		if item != null:
			slots_count += 1
	if slots_count < MAX_CRAFT_SLOTS: #Check if can add another item to the mix
		var item_name = ''
		if !isResource:
			if !isHotbar:
				item_name = PlayerInventory.inventory[id][0]
			else:
				item_name = PlayerInventory.hotbar[id][0]
		else:
			item_name = id
			
		var current_slot = craft_slots.get_child(slots_count)
		current_slot.initialize_item(item_name, 1)
		current_slot.OnCraftSlot = true
		current_slot.ItemName = item_name
		current_slot.ItemId = id
		current_slot.IsHotbar = isHotbar
		current_slot.IsResource = isResource
	else: # All slots are full. Don't add another item to the mix
		pass

func match_recipe(value):
	value.sort() #Sort it aplhabetically
	var resulting_item = hashed_recipes.find(value.hash()) #Checks the hashed_recipes array for the current mix
	if resulting_item >= 0: #The mix matches a recipe		
		clear_craft_slots() #Remove the items on the slots
		
		var recipes = get_recipes()
		var item_name = recipes[resulting_item][0]
		add_item(item_name, 1) #add to inventory (array)
		
		#remove empty slots (that have 0 on item quantity)
		for i in inventory_empty_slots:
			PlayerInventory.inventory.erase(i)
		for i in hotbar_empty_slots:
			PlayerInventory.hotbar.erase(i)
		
		inventory_empty_slots = []
		hotbar_empty_slots = []
		
		update_inventory() #Redraws the inventory
#	get_parent().get_node("InventoryTab/Inventory").initialize_inventory()

func add_item(item_name, item_quantity):
	for item in PlayerInventory.inventory:
		if PlayerInventory.inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - PlayerInventory.inventory[item][1]
			if able_to_add >= item_quantity:
				PlayerInventory.inventory[item][1] += item_quantity
				return
			else:
				PlayerInventory.inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	
	#if the item isnt in inventory (add to an empty slot)
	for i in range(PlayerInventory.MAX_INVENTORY_SLOTS):
		if PlayerInventory.inventory.has(i) == false:
			PlayerInventory.inventory[i] = [item_name, item_quantity]
			return

func _on_CraftBtn_pressed():
	var array = [] #Create an array to pass as an argument in the match_recipe() function
	for slot in craft_slots.get_children(): #Loop through the current items on the slots
		var item = slot.get_node_or_null("Item")
		if item != null:
			array.append(item.item_name) #Add the item's id to the array  
	
	match_recipe(array)


func get_recipes():
	var all_recipes = JsonData.LoadData(RECIPES_PATH)
	var available_recipes = []
	var temp = []
	
	if PlayerInventory.available_recipe_codes[0] != "all":
		for recipe_name in all_recipes:
			for i in range(PlayerInventory.available_recipe_codes.size()):
				if PlayerInventory.available_recipe_codes[i] == all_recipes[recipe_name]["CraftCode"]:
					temp.append(recipe_name)
					for j in range(all_recipes[recipe_name].size() - 1):
						temp.append(all_recipes[recipe_name][str(j)])
					
					available_recipes.append(temp)
					temp = []
	else:
		for recipe_name in all_recipes:
			for _i in range(all_recipes.size()):
				temp.append(recipe_name)
				for j in range(all_recipes[recipe_name].size() - 1):
					temp.append(all_recipes[recipe_name][str(j)])
				
				available_recipes.append(temp)
				temp = []
	
	return available_recipes
