extends Control

const SlotClass = preload("res://Inventory/Slot.gd")
const ItemClass = preload("res://Inventory/Items/Item.gd")
#const CHEST_INVENTORY_FILE = "res://UI/Chest/ChestInventory.json"

const MAX_CHEST_INVENTORY_SLOTS = 20

var chest_id : String
var chest_inventory : Dictionary #slot_index: [item_name (index 0), item_quantity (index 1)]

func initialize_inventory():
	var inventory_slots = $Inventory
	var slots = inventory_slots.get_children()
	
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	
	for i in range(slots.size()):
		if chest_inventory.has(i):
			slots[i].initialize_item(chest_inventory[i][0], chest_inventory[i][1])

func slot_gui_input(event : InputEvent, slot : SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UI").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UI").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)

func left_click_empty_slot(slot : SlotClass):
	add_item_empty_slot(find_parent("UI").holding_item, slot)
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = null

func left_click_different_item(event : InputEvent, slot : SlotClass):
	remove_item(slot)
	add_item_empty_slot(find_parent("UI").holding_item, slot)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = temp_item

func left_click_same_item(slot : SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UI").holding_item.item_quantity:
		add_item_quantity(slot, find_parent("UI").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UI").holding_item.item_quantity)
		find_parent("UI").holding_item.queue_free()
		find_parent("UI").holding_item = null
	else:
		add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UI").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot : SlotClass):
	remove_item(slot)
	find_parent("UI").holding_item = slot.item
	slot.pick_from_slot()
	find_parent("UI").holding_item.global_position = get_global_mouse_position()

func _input(_event):
	if find_parent("UI").holding_item:
		find_parent("UI").holding_item.global_position = get_global_mouse_position()

#FUNCIONALITIES
func add_item(item_name, item_quantity):
	for item in chest_inventory:
		if chest_inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - chest_inventory[item][1]
			if able_to_add >= item_quantity:
				chest_inventory[item][1] += item_quantity
				return
			else:
				chest_inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	
	#if the item isnt in chest_inventory (add to an empty slot)
	for i in range(MAX_CHEST_INVENTORY_SLOTS):
		if chest_inventory.has(i) == false:
			chest_inventory[i] = [item_name, item_quantity]
			return

func remove_item(slot : SlotClass):
	var _value = chest_inventory.erase(slot.slot_index)

func add_item_empty_slot(item : ItemClass, slot : SlotClass):
	chest_inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot : SlotClass, quantity : int):
	chest_inventory[slot.slot_index][1] += quantity
