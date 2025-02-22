extends Node

signal active_item_updated
signal hand_item_removed

const SlotClass = preload("res://Inventory/Slot.gd")
const ItemClass = preload("res://Inventory/Items/Item.gd")

const MAX_INVENTORY_SLOTS = 20
const MAX_HOTBAR_SLOTS = 6

const CHEST_HOTBAR_POSITION = Vector2(80, 232)
const INVENTORY_HOTBAR_POSITION = Vector2(80, 232)
const GAME_HOTBAR_POSITION = Vector2(216, 272)

var inventory = { #slot_index: [item_name (index 0), item_quantity (index 1)]
	0: ["Berry", 3],
	1: ["Bread", 4],
	3: ["Bow", 1],
	4: ["Wheat", 2]
}

var hotbar = { #slot_index: [item_name (index 0), item_quantity (index 1)]
	0: ["BasicSword", 1],
	1: ["SpellBook", 1],
	2: ["Axe", 1],
	3: ["Hoe", 1],
	
	5: ["Chicken", 2]
}

var spells = { #0 is locked and 1 is unlocked
	0: ["Fire", 0],
	1: ["Water", 0],
	2: ["Grass", 0],
	3: ["Earth", 0],
	4: ["Thunder", 0],
	5: ["Wind", 0],
	6: ["Light", 0],
	7: ["Psychic", 0],
	8: ["Shadow", 0],
}

const pets = {#name, scene_path, image_path
	0: ["Fox", preload("res://Characters/Pets/Fox/Fox.tscn"), preload("res://PixelArt/Characters/Pets/foxTexture.png")],
	1: ["Cat", preload("res://Characters/Pets/Cat/Cat.tscn"), preload("res://PixelArt/Characters/Pets/catTexture.png")],
	2: ["Falcon", preload("res://Characters/Pets/Falcon/Falcon.tscn"), preload("res://PixelArt/Characters/Pets/falconTexture.png")],
	3: ["Chameleon", preload("res://Characters/Pets/Chameleon/Chameleon.tscn"), preload("res://PixelArt/Characters/Pets/chameleonTexture.png")],
	4: ["Dog", preload("res://Characters/Pets/Dog/Dog.tscn"), preload("res://PixelArt/Characters/Pets/dogTexture.png")],
	5: ["Rabbit", preload("res://Characters/Pets/Rabbit/Rabbit.tscn"), preload("res://PixelArt/Characters/Pets/rabbitTexture.png")],
}

var available_pets = [1]

var available_recipe_codes = ["all"]

var curr_head : int = 0
var curr_body : int = 0
var curr_shoes : int = 0

var max_coins = 9999
var coins = 100

var max_wood = 9999
var wood = 100

var max_brick = 9999
var brick = 100

var can_change_item = true

var current_item_slot_index = 0
var current_item_path = "res://Weapons/HandItems/BasicSword.tscn"
var current_item_type = "Weapon"
var current_selected_slot : SlotClass

func add_coins(amount):
	var current_coins = coins
	coins = clamp(current_coins, 0, max_coins)
	coins += amount
	Globals.ui.right_display_box.item_collected("Coin", amount)
	
	if Globals.account_type == 1:
		HttpConnection._update_coins()

func add_wood(amount):
	var current_wood = wood
	wood = clamp(current_wood, 0, max_wood)
	wood += amount
	Globals.ui.right_display_box.item_collected("Wood", amount)

func add_brick(amount):
	var current_brick = brick
	brick = clamp(current_brick, 0, max_brick)
	brick += amount
	Globals.ui.right_display_box.item_collected("Brick", amount)

func add_item(item_name, item_quantity):
	var added_in_logs = false #avoid duplicate
	
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				if !added_in_logs:
					Globals.ui.right_display_box.item_collected(item_name, item_quantity)
					added_in_logs = true
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
				if !added_in_logs:
					Globals.ui.right_display_box.item_collected(item_name, item_quantity)
					added_in_logs = true
	
	#if the item isnt in inventory (add to an empty slot)
	for i in range(MAX_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			if !added_in_logs:
					Globals.ui.right_display_box.item_collected(item_name, item_quantity)
					added_in_logs = true
			return

func remove_item(slot : SlotClass, is_hotbar : bool = false):
	if is_hotbar:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)

func add_item_empty_slot(item : ItemClass, slot : SlotClass, is_hotbar : bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot : SlotClass, quantity : int, is_hotbar : bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity
	else:
		inventory[slot.slot_index][1] += quantity

func decrease_item_quantity(quantity : int):
	hotbar[current_item_slot_index][1] -= quantity
	current_selected_slot.item.decrease_item_quantity(quantity)
	if hotbar[current_item_slot_index][1] == 0:
		hotbar.erase(current_item_slot_index)
		current_selected_slot.remove_child(current_selected_slot.item)
		current_selected_slot.item.queue_free()
		emit_signal("active_item_updated")
		emit_signal("hand_item_removed")

func active_item_scroll_down():
	if can_change_item:
		current_item_slot_index = (current_item_slot_index + 1) % MAX_HOTBAR_SLOTS
		emit_signal("active_item_updated")

func active_item_scroll_up():
	if can_change_item:
		if current_item_slot_index == 0:
			current_item_slot_index = MAX_HOTBAR_SLOTS - 1
		else:
			current_item_slot_index -= 1
		emit_signal("active_item_updated")
