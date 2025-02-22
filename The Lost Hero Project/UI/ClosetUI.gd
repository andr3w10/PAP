extends Control


onready var ui = get_parent()
onready var background = get_parent().get_node("Background")
onready var player_stats_ui = get_parent().get_node("PlayerStatsUI")
onready var date_time_ui = get_parent().get_node("DateTimeUI")
onready var dodge_bar = get_parent().get_node("DodgeBarUI")
onready var animation_palyer = get_parent().get_node("AnimationPlayer")


onready var head_sprite = $player_preview/head
onready var body_sprite = $player_preview/body
onready var shoes_sprite = $player_preview/shoes

onready var head_name = $skin_name/head
onready var body_name = $skin_name/body
onready var shoes_name = $skin_name/shoes

const skins = preload("res://Inventory/Skins/Skins.gd")

onready var curr_head : int = PlayerInventory.curr_head
onready var curr_body : int = PlayerInventory.curr_body
onready var curr_shoes : int = PlayerInventory.curr_shoes

var is_opened : bool = false

func _ready():
	head_sprite.texture = skins.head_spritessheet[curr_head][1]
	head_name.text = skins.head_spritessheet[curr_head][0]
	body_sprite.texture = skins.body_spritessheet[curr_body][1]
	body_name.text = skins.body_spritessheet[curr_body][0]
	shoes_sprite.texture = skins.shoes_spritessheet[curr_shoes][1]
	shoes_name.text = skins.shoes_spritessheet[curr_shoes][0]


func _on_ChangeHead_pressed():
	curr_head = (curr_head + 1) % skins.head_spritessheet.size()
	head_sprite.texture = skins.head_spritessheet[curr_head][1]
	head_name.text = skins.head_spritessheet[curr_head][0]


func _on_ChangePreviousHead_pressed():
	if (curr_head - 1) < 0:
		curr_head = skins.head_spritessheet.size() - 1
	else:
		curr_head -= 1
	head_sprite.texture = skins.head_spritessheet[curr_head][1]
	head_name.text = skins.head_spritessheet[curr_head][0]


func _on_ChangeBody_pressed():
	curr_body = (curr_body + 1) % skins.body_spritessheet.size()
	body_sprite.texture = skins.body_spritessheet[curr_body][1]
	body_name.text = skins.body_spritessheet[curr_body][0]


func _on_ChangePreviousBody_pressed():
	if (curr_body - 1) < 0:
		curr_body = skins.body_spritessheet.size() - 1
	else:
		curr_body -= 1
	body_sprite.texture = skins.body_spritessheet[curr_body][1]
	body_name.text = skins.body_spritessheet[curr_body][0]


func _on_ChangeShoes_pressed():
	curr_shoes = (curr_shoes + 1) % skins.shoes_spritessheet.size()
	shoes_sprite.texture = skins.shoes_spritessheet[curr_shoes][1]
	shoes_name.text = skins.shoes_spritessheet[curr_shoes][0]


func _on_ChangePreviousShoes_pressed():
	if (curr_shoes - 1) < 0:
		curr_shoes = skins.shoes_spritessheet.size() - 1
	else:
		curr_shoes -= 1
	shoes_sprite.texture = skins.shoes_spritessheet[curr_shoes][1]
	shoes_name.text = skins.shoes_spritessheet[curr_shoes][0]


func _on_Save_pressed():
	PlayerInventory.curr_head = curr_head
	PlayerInventory.curr_body = curr_body
	PlayerInventory.curr_shoes = curr_shoes
	
	Globals.player.update_skin()
	
	close_menu()


func open_menu():
	PlayerInventory.can_change_item = false
	get_tree().paused = true
	var hotbar = get_parent().get_node("Hotbar")
	hotbar.visible = false
	player_stats_ui.visible = false
	date_time_ui.visible = false
	dodge_bar.visible = false
	animation_palyer.play("open_closet")
	background.visible = true
	self.visible = true
	is_opened = true
	Globals.can_open_menu = false

func close_menu():
	animation_palyer.play("close_closet")

func menu_is_closed():
	var hotbar = get_parent().get_node("Hotbar")
	hotbar.visible = true
	player_stats_ui.visible = true
	date_time_ui.visible = true
	dodge_bar.visible = true
	background.visible = false
	self.visible = false
	is_opened = false
	get_tree().paused = false
	PlayerInventory.can_change_item = true
	Globals.can_open_menu = true
