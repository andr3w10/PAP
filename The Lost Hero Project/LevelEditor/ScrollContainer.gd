extends ScrollContainer

onready var object_cursor = get_node("/root/LevelEditor/EditorObject")

func _ready():
	var _value = connect("mouse_entered", self, "mouse_enter")
	_value = connect("mouse_exited", self, "mouse_leave")

func mouse_enter():
	object_cursor.can_place = false
	object_cursor.hide()

func mouse_leave():
	object_cursor.can_place = true
	object_cursor.show()
