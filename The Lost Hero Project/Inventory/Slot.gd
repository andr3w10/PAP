extends Panel

var filled_inventory_texture = preload("res://PixelArt/UI/inventorySlot_filled.png")
var empty_inventory_texture = preload("res://PixelArt/UI/inventorySlot_empty.png")

var default_hotbar_texture = preload("res://PixelArt/UI/hotbarSlot_default.png")
var selected_hotbar_texture = preload("res://PixelArt/UI/hotbarSlot_selected.png")

var filled_inventory_style : StyleBoxTexture = null
var empty_inventory_style : StyleBoxTexture = null

var default_hotbar_style : StyleBoxTexture = null
var selected_hotbar_style : StyleBoxTexture = null

var ItemClass = preload("res://Inventory/Items/Item.tscn")
var item = null
var slot_index
var slot_type
var slot_item

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

func _ready():
	filled_inventory_style = StyleBoxTexture.new()
	empty_inventory_style = StyleBoxTexture.new()
	filled_inventory_style.texture = filled_inventory_texture
	empty_inventory_style.texture = empty_inventory_texture
	
	default_hotbar_style = StyleBoxTexture.new()
	selected_hotbar_style = StyleBoxTexture.new()
	default_hotbar_style.texture = default_hotbar_texture
	selected_hotbar_style.texture = selected_hotbar_texture
	
	sync_style()

func sync_style():
	if slot_type == SlotType.HOTBAR:
		if PlayerInventory.current_item_slot_index == slot_index:
			set('custom_styles/panel', selected_hotbar_style)
			match slot_index:
				0:
					slot_item = get_node_or_null("Item")
					item_check()
				1:
					slot_item = get_node_or_null("Item")
					item_check()
				2:
					slot_item = get_node_or_null("Item")
					item_check()
				3:
					slot_item = get_node_or_null("Item")
					item_check()
				4:
					slot_item = get_node_or_null("Item")
					item_check()
				5:
					slot_item = get_node_or_null("Item")
					item_check()
		else:
			set('custom_styles/panel', default_hotbar_style)
	elif slot_type == SlotType.INVENTORY:
		if item == null:
			set('custom_styles/panel', empty_inventory_style)
		else:
			set('custom_styles/panel', filled_inventory_style)

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("UI")
	inventory_node.add_child(item)
	item = null
	sync_style()

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventory_node = find_parent("UI")
	inventory_node.remove_child(item)
	add_child(item)
	sync_style()

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	
	sync_style()

func item_check():
	PlayerInventory.current_selected_slot = self
	if slot_item != null:
		PlayerInventory.current_item_path = slot_item.item_path
		PlayerInventory.current_item_type = slot_item.item_type
	else:
		PlayerInventory.current_item_path = "res://Inventory/HandItems/Hand.tscn"
		PlayerInventory.current_item_type = "Hand"
