extends TabContainer

onready var object_cursor = get_node("/root/LevelEditor/EditorObject")
var is_visible = true

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		visible = !is_visible
		is_visible = !is_visible

func _on_TabContainer_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()

func _on_TabContainer_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()


func _on_Exit_pressed():
	MouseGrid.visible = false
	var scene_path = "res://Scenes/TitleScreen.tscn"
	SceneChanger.change_the_scene(scene_path)
