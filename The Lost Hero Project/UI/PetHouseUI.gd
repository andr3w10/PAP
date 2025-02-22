extends Control

const unknown_texture = preload("res://PixelArt/Characters/Pets/unknownTexture.png")

onready var ui = get_parent()
onready var background = get_parent().get_node("Background")
onready var player_stats_ui = get_parent().get_node("PlayerStatsUI")
onready var date_time_ui = get_parent().get_node("DateTimeUI")
onready var dodge_bar = get_parent().get_node("DodgeBarUI")
onready var animation_palyer = get_parent().get_node("AnimationPlayer")


onready var pet_sprite = $pet_preview/body

onready var pet_name = $pet_name/body

onready var pets = PlayerInventory.pets

var is_opened : bool = false

var curr_pet : int = 0

func _input(event):
	if is_opened:
		if event.is_action_pressed("menu"):
			close_menu()

func _ready():
	update_infos()

func _on_ChangeBody_pressed():
	curr_pet = (curr_pet + 1) % pets.size()
	update_infos()

func _on_ChangePreviousBody_pressed():
	if (curr_pet - 1) < 0:
		curr_pet = pets.size() - 1
	else:
		curr_pet -= 1
	update_infos()

func _on_Get_pressed():
	store_curr_pet()
	
	PlayerInventory.available_pets.erase(curr_pet)
	
	var pet = (pets[curr_pet][1]).instance()
	Globals.map.add_character(pet)
	pet.global_position = Globals.player.global_position
	
	close_menu()

func _on_Save_pressed():
	store_curr_pet()
	
	close_menu()


func store_curr_pet():
	if Globals.player.pet != null:
		var temp = Globals.player.pet
		var temp_name = temp.pet_name
		temp.remove_stats()
		Globals.player.pet = null
		temp.queue_free()
		
		for i in pets:
			if pets[i][0] == temp_name:
				PlayerInventory.available_pets.append(i)
		
		get_node("buttons/SaveLocked").visible = true
		get_node("buttons/Save").visible = false


func update_infos():
	var is_available = false
	for i in PlayerInventory.available_pets:
		if i == curr_pet:
			is_available = true
	
	if is_available:
		pet_sprite.texture = pets[curr_pet][2]
		pet_name.text = pets[curr_pet][0]
		get_node("buttons/GetLocked").visible = false
		get_node("buttons/Get").visible = true
	else:
		pet_sprite.texture = unknown_texture
		pet_name.text = pets[curr_pet][0]
		get_node("buttons/GetLocked").visible = true
		get_node("buttons/Get").visible = false
	
	if Globals.player.pet == null:
		get_node("buttons/SaveLocked").visible = true
		get_node("buttons/Save").visible = false
	else:
		get_node("buttons/SaveLocked").visible = false
		get_node("buttons/Save").visible = true


func open_menu():
	PlayerInventory.can_change_item = false
	get_tree().paused = true
	var hotbar = get_parent().get_node("Hotbar")
	hotbar.visible = false
	player_stats_ui.visible = false
	date_time_ui.visible = false
	dodge_bar.visible = false
	animation_palyer.play("open_pethouse")
	background.visible = true
	self.visible = true
	is_opened = true
	Globals.can_open_menu = false
	
	update_infos()

func close_menu():
	animation_palyer.play("close_pethouse")

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
