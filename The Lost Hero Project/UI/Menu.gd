extends Control

signal page_changed

const hotbar_instance = preload("res://Inventory/Hotbar.tscn")
const inventory_instance = preload("res://Inventory/Inventory.tscn")

#menus
onready var menu_home = $Home
onready var menu_settings = $Settings
onready var menu_inventory_tab = $InventoryTab
onready var menu_map = $Map
onready var menu_craft = $Craft
#buttons
onready var button_home = $Buttons/ButtonHome
onready var button_settings = $Buttons/ButtonSettings
onready var button_inventory = $Buttons/ButtonInventory
onready var button_map = $Buttons/ButtonMap
onready var button_craft = $Buttons/ButtonCraft

onready var ui = get_parent()
onready var background = get_parent().get_node("Background")
onready var player_stats_ui = get_parent().get_node("PlayerStatsUI")
onready var date_time_ui = get_parent().get_node("DateTimeUI")
onready var dodge_bar = get_parent().get_node("DodgeBarUI")
onready var animation_palyer = get_parent().get_node("AnimationPlayer")

var is_opened : bool = false

func home():
	pass

func settings():
	pass

func inventory():
	pass

func map():
	pass

func craft():
	pass

func _input(event):
	if event.is_action_pressed("menu") && Globals.can_open_menu && !animation_palyer.is_playing():
		if !is_opened:
			open_menu()
		else:
			close_menu()

#idk why but bugging spellbook ui...

#func _physics_process(_delta):
#	if animation_palyer.is_playing():
#		get_tree().get_root().set_disable_input(true)
#	else:
#		get_tree().get_root().set_disable_input(false)

func open_menu():
	PlayerInventory.can_change_item = false
	get_tree().paused = true
	if Globals.account_type == 1 && Globals.account_username != "":
		get_node("Home/get_items").visible = true
	else:
		get_node("Home/get_items").visible = false
	var hotbar = get_parent().get_node("Hotbar")
	hotbar.queue_free()
	$InventoryTab/Inventory/Hotbar.queue_free()
	$InventoryTab/Inventory.queue_free()
	player_stats_ui.visible = false
	date_time_ui.visible = false
	dodge_bar.visible = false
	animation_palyer.play("open_menu")
	background.visible = true
	self.visible = true
	_on_ButtonHome_pressed()
	is_opened = true

func close_menu():
	animation_palyer.play("close_menu")

func menu_is_opened():
	menu_inventory_tab.add_child(inventory_instance.instance())
#	$InventoryTab/Inventory.add_child(hotbar_instance.instance())
	menu_inventory_tab.get_node("Inventory").initialize_inventory()
	$InventoryTab/Inventory/Hotbar.rect_position = PlayerInventory.INVENTORY_HOTBAR_POSITION

func menu_is_closed():
	ui.add_child(hotbar_instance.instance())
	menu_inventory_tab.get_node("Inventory").initialize_inventory()
	Globals.player.update_hand_item()
	player_stats_ui.visible = true
	date_time_ui.visible = true
	dodge_bar.visible = true
	background.visible = false
	self.visible = false
	is_opened = false
	get_tree().paused = false
	PlayerInventory.can_change_item = true

func activate_buttons():
	button_home.disabled = false
	button_settings.disabled = false
	button_inventory.disabled = false
	button_map.disabled = false
	button_craft.disabled = false

func hide_menus():
	menu_home.visible = false
	menu_settings.visible = false
	menu_inventory_tab.visible = false
	menu_map.visible = false
	menu_craft.visible = false

func _on_ButtonHome_pressed():
	emit_signal("page_changed")
	activate_buttons()
	button_home.disabled = true
	hide_menus()
	menu_home.visible = true
	

func _on_ButtonSettings_pressed():
	emit_signal("page_changed")
	activate_buttons()
	button_settings.disabled = true
	hide_menus()
	menu_settings.visible = true


func _on_ButtonInventory_pressed():
	emit_signal("page_changed")
	menu_inventory_tab.get_node("Inventory").initialize_inventory()
	menu_inventory_tab.get_node("Inventory/Hotbar").initialize_hotbar()
	activate_buttons()
	button_inventory.disabled = true
	hide_menus()
	menu_inventory_tab.visible = true


func _on_ButtonMap_pressed():
	emit_signal("page_changed")
	activate_buttons()
	button_map.disabled = true
	hide_menus()
	menu_map.visible = true


func _on_ButtonCraft_pressed():
	emit_signal("page_changed")
	menu_craft.initialize_craft_menu()
	activate_buttons()
	button_craft.disabled = true
	hide_menus()
	menu_craft.visible = true
