extends Control

const MAX_COLLECTES_ITEMS_SHOW = 8

signal advance()

onready var animation_player = get_parent().get_node("AnimationPlayer")

onready var text_box = $Label
onready var timer = $Timer
onready var items_timer = $ItemsTimer
onready var collected_items_ui = $CollectedItemsUI

var items_show_time : float = 3.0
var collected_items = {
	0: ["", 0],
	1: ["", 0],
	2: ["", 0],
	3: ["", 0],
	4: ["", 0],
	5: ["", 0],
	6: ["", 0],
	7: ["", 0],
}

onready var tutorial_ui = $TutorialUI
onready var game_saved_ui = $GameSavedUI

var tutorial_completed = true

var current_key = "ui_cancel"

func _input(event):
	if event.is_action_pressed(current_key):
		emit_signal("advance")

func start_tutorial():
	tutorial_ui.visible = true
	#turn all invisible
	for i in tutorial_ui.get_children():
		i.visible = false

	self.visible = true
	
	#move
	tutorial_ui.move_ui.visible = true
	text_box.text = tutorial_ui.move_text
	animation_player.play("open_right_display_box")
	current_key = "move_right"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.move_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#interact
	tutorial_ui.interact_ui.visible = true
	text_box.text = tutorial_ui.interact_text
	animation_player.play("open_right_display_box")
	current_key = "interact"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.interact_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#dodge
	tutorial_ui.dodge_ui.visible = true
	text_box.text = tutorial_ui.dodge_text
	animation_player.play("open_right_display_box")
	current_key = "dodge"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.dodge_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#menu
	tutorial_ui.menu_ui.visible = true
	text_box.text = tutorial_ui.menu_text
	animation_player.play("open_right_display_box")
	current_key = "menu"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.menu_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#primary attack
	tutorial_ui.primary_attack_ui.visible = true
	text_box.text = tutorial_ui.primary_attack_text
	animation_player.play("open_right_display_box")
	current_key = "mouse_left"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.primary_attack_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#sencondary attack
	tutorial_ui.secondary_attack_ui.visible = true
	text_box.text = tutorial_ui.secondary_attack_text
	animation_player.play("open_right_display_box")
	current_key = "mouse_right"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.secondary_attack_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#hotbar
	tutorial_ui.hotbar_ui.visible = true
	text_box.text = tutorial_ui.hotbar_text
	animation_player.play("open_right_display_box")
	current_key = "scroll_up"
	yield(self, "advance")
	current_key = "ui_cancel"
	timer.start()
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.hotbar_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#save the game
	tutorial_ui.save_game_ui.visible = true
	text_box.text = tutorial_ui.save_game_text
	animation_player.play("open_right_display_box")
	timer.start(7.0)
	Globals.camera.slide_to(Vector2(1450, -520), 2.0, 3.0)
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.save_game_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#tutorial completed
	tutorial_ui.completed_ui.visible = true
	text_box.text = tutorial_ui.completed_text
	animation_player.play("open_right_display_box")
	timer.start(5.0)
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	tutorial_ui.completed_ui.visible = false
	text_box.text = ""
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	
	#hide
	tutorial_ui.visible = false
	self.visible = false
	tutorial_completed = true
	
	Globals.camera.slide_to(Vector2(900, -800), 2.0, 1.0)

func game_saved():
	self.visible = true
	game_saved_ui.visible = true
	animation_player.play("open_right_display_box")
	timer.start(1.0)
	yield(timer, "timeout")
	if animation_player.is_playing(): #to make sure the ui will not bug
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	game_saved_ui.visible = false
	if get_parent().menu_ui.is_opened || get_parent().dialogue_manager.is_opened: #make sure the ui is closed before advance
		yield(animation_player, "animation_finished")
	self.visible = false



func item_collected(item_name, item_quantity):
	if !tutorial_completed:
		return
	
	var is_displayed = false
	
	for i in collected_items:
		if collected_items[i][0] == item_name:
			collected_items[i][1] += item_quantity
			is_displayed = true
	
	if !is_displayed:
		var slot = null
		for i in collected_items:
			if slot == null:
				if collected_items[i][0] == "":
					slot = i
		
		if slot != null:
			collected_items[slot][0] = item_name
			collected_items[slot][1] = item_quantity
		else:
			var temp_array = collected_items.duplicate()
			var temp = 0
			for i in temp_array:
				if temp == 1:
					collected_items[i-1][0] = temp_array[i][0]
					collected_items[i-1][1] = temp_array[i][1]
				else:
					temp = 1
			
			collected_items[MAX_COLLECTES_ITEMS_SHOW-1][0] = item_name
			collected_items[MAX_COLLECTES_ITEMS_SHOW-1][1] = item_quantity
	
	
	_update_collected_items_ui()
	
	
	if items_timer.is_stopped(): #is not showing
		if animation_player.is_playing():
			yield(animation_player, "animation_finished")
		self.visible = true
		animation_player.play("open_right_display_box")
		items_timer.start(items_show_time)
	else: #is already opened
		items_timer.start(items_show_time)


func _on_ItemsTimer_timeout():
	if animation_player.is_playing():
		yield(animation_player, "animation_finished")
	animation_player.play("close_right_display_box")
	yield(animation_player, "animation_finished")
	self.visible = false
	
	for i in collected_items:
		collected_items[i][0] = ""
		collected_items[i][1] = 0
		
		var label = collected_items_ui.get_node("Labels").get_node(str(i))
		label.text = ""
		var texture_rect = collected_items_ui.get_node("Imgs").get_node(str(i))
		texture_rect.texture = null
	
	_update_collected_items_ui()

func _update_collected_items_ui():
	for i in collected_items:
		if collected_items[i][0] != "":
			var label = collected_items_ui.get_node("Labels").get_node(str(i))
			label.text = str(str(collected_items[i][1]) + "x " + str(collected_items[i][0]))
			var texture_rect = collected_items_ui.get_node("Imgs").get_node(str(i))
			texture_rect.texture = load("res://PixelArt/Items/ItemsIcons/" + str(collected_items[i][0]) + ".png")
