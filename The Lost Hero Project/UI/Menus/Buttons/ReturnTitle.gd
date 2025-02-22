extends Button

#this funcionality is not working because the variables dont reset when is created a new game

onready var menu = get_parent().get_parent().get_parent()

func _on_ReturnTitle_pressed():
	SceneChanger.change_the_scene("res://Scenes/TitleScreen.tscn")
	menu.close_menu()
