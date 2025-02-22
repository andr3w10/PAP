extends Control

const SlotClass = preload("res://Inventory/Slot.gd")

onready var hotbar = $HotbarSlots

func _ready():
	var _value
	var slots = hotbar.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		_value = PlayerInventory.connect("active_item_updated", slots[i], "sync_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	
	initialize_hotbar()

func initialize_hotbar():
	var slots = hotbar.get_children()
	#clear inventory
	for slot in slots:
		var item = slot.get_node_or_null("Item")
		if item != null:
			slot.item = null
			slot.sync_style()
			
			item.queue_free()
	
	yield(get_tree().create_timer(0.01), "timeout")
	
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
		
	Globals.player.update_hand_item()

func slot_gui_input(event : InputEvent, slot : SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed && !PlayerInventory.can_change_item: #can_change_item is also used to verify if hotbar is in inventory or not
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
	PlayerInventory.add_item_empty_slot(find_parent("UI").holding_item, slot, true)
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = null

func left_click_different_item(event : InputEvent, slot : SlotClass):
	PlayerInventory.remove_item(slot, true)
	PlayerInventory.add_item_empty_slot(find_parent("UI").holding_item, slot, true)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = temp_item

func left_click_same_item(slot : SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UI").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("UI").holding_item.item_quantity, true)
		slot.item.add_item_quantity(find_parent("UI").holding_item.item_quantity)
		find_parent("UI").holding_item.queue_free()
		find_parent("UI").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add, true)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UI").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot : SlotClass):
	PlayerInventory.remove_item(slot, true)
	find_parent("UI").holding_item = slot.item
	slot.pick_from_slot()
	find_parent("UI").holding_item.global_position = get_global_mouse_position()
