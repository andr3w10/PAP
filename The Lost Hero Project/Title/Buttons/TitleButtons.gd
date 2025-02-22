extends Control

onready var menus = get_parent().get_node("Menus")
onready var animation_player = get_parent().get_parent().get_node("AnimationPlayer")

func _on_START_button_up():
	menus.visible = true
	animation_player.play("mid_left")

func _on_SETTINGS_button_up():
	#TODO: MAKE ALL THE MENU
	OS.window_fullscreen = !OS.window_fullscreen

func _on_CREDITS_button_up():
	pass # Replace with function body.

func _on_EXIT_button_up():
	get_tree().quit()

func _on_LevelEditor_button_up():
	var scene_path = "res://LevelEditor/LevelEditor.tscn"
	SceneChanger.change_the_scene(scene_path)


func _on_pressed():
	AudioPlayer.play_menu_click()


func _on_mouse_entered():
	AudioPlayer.play_menu_hover()
