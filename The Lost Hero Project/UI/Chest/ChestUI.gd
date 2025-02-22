extends Control

onready var SAVE_DIR = Globals.SAVE_DIR + "Chests/"

const hotbar_instance = preload("res://Inventory/Hotbar.tscn")

var save_path = SAVE_DIR

const player_inventory = preload("res://UI/Chest/PlayerInventoryUI.tscn")
const inventory_slots_container = preload("res://Inventory/InventorySlotsContainer.tscn")

onready var chest_inventory_ui = $ChestInventoryUI
onready var player_inventory_ui = $PlayerInventoryUI

onready var ui = get_parent()
onready var background = get_parent().get_node("Background")
onready var player_stats_ui = get_parent().get_node("PlayerStatsUI")
onready var date_time_ui = get_parent().get_node("DateTimeUI")
onready var dodge_bar = get_parent().get_node("DodgeBarUI")
onready var animation_palyer = get_parent().get_node("AnimationPlayer")

var file_path = "res://UI/Chest/ChestInventory.json"

var is_opened : bool = false

func _ready():
	player_inventory_ui.get_node("PlayerInventoryUI").queue_free()
	chest_inventory_ui.get_node("Inventory").queue_free()

func init_chest(id : String):
	open_menu(id)

func close_chest():
	close_menu()

func save_data(id : String, data : Dictionary):
	var chests_data = load_data()
	
	save_path = SAVE_DIR + "chests" + str(Globals.current_story) + ".dat"
	
	var directory = Directory.new()
	if !directory.dir_exists(SAVE_DIR):
		directory.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, Globals.password)
	if error == OK:
		chests_data[id] = data
		file.store_var(chests_data)
		file.close()

func load_data():
	save_path = SAVE_DIR + "chests" + str(Globals.current_story) + ".dat"
	
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, Globals.password)
		if error == OK:
			var data = file.get_var()
			file.close()
			return data
	return "Unexpected error!"

func open_menu(id : String):
	player_inventory_ui.add_child(player_inventory.instance())
	chest_inventory_ui.add_child(inventory_slots_container.instance())
	var inventory_slots = chest_inventory_ui.get_node("Inventory")
	inventory_slots.rect_position = Vector2(37, 56)
	chest_inventory_ui.chest_id = id
	var data = load_data()
	if data.has(id):
		chest_inventory_ui.chest_inventory = data[id]
	else:
		chest_inventory_ui.chest_inventory = {}
	chest_inventory_ui.initialize_inventory()
	chest_inventory_ui.get_node("IdLabel").text = id
	PlayerInventory.can_change_item = false
	
	get_tree().paused = true
	var hotbar = get_parent().get_node("Hotbar")
	hotbar.queue_free()
	player_stats_ui.visible = false
	date_time_ui.visible = false
	dodge_bar.visible = false
	animation_palyer.play("open_chest_ui")
	background.visible = true
	self.visible = true
	is_opened = true

func close_menu():
	animation_palyer.play("close_chest_ui")

func menu_is_opened():
#	$InventoryTab/Inventory/Hotbar.rect_position = PlayerInventory.CHEST_HOTBAR_POSITION
	pass

func menu_is_closed():
	save_data(chest_inventory_ui.chest_id, chest_inventory_ui.chest_inventory)
	player_inventory_ui.get_node("PlayerInventoryUI").queue_free()
	chest_inventory_ui.get_node("Inventory").queue_free()
	Globals.player.update_hand_item()
	
	ui.add_child(hotbar_instance.instance())
	Globals.player.update_hand_item()
	player_stats_ui.visible = true
	date_time_ui.visible = true
	dodge_bar.visible = true
	background.visible = false
	self.visible = false
	is_opened = false
	get_tree().paused = false
	PlayerInventory.can_change_item = true
