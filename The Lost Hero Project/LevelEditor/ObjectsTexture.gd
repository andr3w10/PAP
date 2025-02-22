extends TextureRect

enum type{ENEMIES, PREFABS, PATHS, DECORATION, COLLISIONS, FOLLIAGE_SHADOWS, FOLLIAGE, BUILDINGS, PETS, HILLS}

export(PackedScene) var object_scene
export(type) var object_type
export(int) var tile_id = 1
export(bool) var need_id_request = false

onready var object_cursor = get_node("/root/LevelEditor/EditorObject")

onready var cursor_sprite = object_cursor.get_node("MouseCursor")

func _ready():
	var _value = connect("gui_input", self, "item_clicked")

func item_clicked(event):
	if event is InputEvent:
		if event.is_action_pressed("mouse_left"):
			object_cursor.current_item = object_scene
			object_cursor.current_item_type = object_type
			object_cursor.current_tile_id = tile_id
			object_cursor.current_item_need_id_request = need_id_request
			cursor_sprite.texture = texture
