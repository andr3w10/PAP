extends Button

onready var menu = get_parent().get_parent().get_parent()

func _on_Resume_pressed():
	menu.close_menu()
