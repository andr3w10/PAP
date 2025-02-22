extends Node2D

var DELETE_RADIUS

enum type{ENEMIES, PREFABS, PATHS, DECORATION, COLLISIONS, FOLLIAGE_SHADOWS, FOLLIAGE, BUILDINGS, PETS, HILLS}

var can_place = true
var is_panning = true

var file_system_shown = false
var do_save = false

onready var mouse_cursor = $MouseCursor
onready var object_detector = $ObjectDetector

onready var level = get_node("/root/LevelEditor/Edit/Level")
onready var characters = level.get_node("World/Entities/Characters")
onready var paths = level.get_node("Tilesets/Ground")
onready var decoration = level.get_node("Tilesets/Decoration")
onready var hills = level.get_node("Tilesets/Hills")
onready var collisions = level.get_node("Tilesets/Collisions")
onready var buildings = level.get_node("World/Buildings")
onready var folliage_shadows = level.get_node("FolliageShadows")
onready var folliage = level.get_node("ParallaxBackground/ParallaxLayer/Folliage")

onready var editor_camera_container = get_node("/root/LevelEditor/CameraContainer")
onready var editor_camera = get_node("/root/LevelEditor/CameraContainer/Camera2D")

onready var popup : FileDialog = get_node("/root/LevelEditor/ObjectsSelect/FileDialog")

var current_item
var current_item_type
var current_tile_id
var current_item_need_id_request

var brush_size : int = 1

func _ready():
	MouseGrid.visible = true
	MouseGrid.validate = false
	MouseGrid.texture("16")
	DELETE_RADIUS = object_detector.get_node("CollisionShape2D").shape.radius
	object_detector.visible = false
	object_detector.monitoring = false

func _process(_delta):
	editor_camera.current = true
	is_panning = Input.is_action_pressed("mouse_middle")
	global_position = get_global_mouse_position()
	
	if Input.is_action_pressed("level_editor_save"):
		file_system_shown = true
		do_save = true
		popup.mode = 4
		popup.show()
	if Input.is_action_pressed("level_editor_open"):
		file_system_shown = true
		do_save = true
		popup.mode = 0
		popup.show()
	
	if can_place && !file_system_shown:
		if current_item != null: #objects
			#place objects
			if Input.is_action_just_pressed("mouse_left"):
#				print(get_global_mouse_position())
				var new_item = current_item.instance()
				if current_item_type == type.ENEMIES || current_item_type == type.PETS:
					characters.add_child(new_item)
					new_item.can_move = false
				elif current_item_type == type.PREFABS:
					if current_item_need_id_request:
						get_parent().get_node("ObjectsSelect/Writer").request_id(new_item)
					level.add_child(new_item)
				new_item.global_position = get_global_mouse_position()
			#start delete objects
			if Input.is_action_just_pressed("mouse_right"):
				mouse_cursor.visible = false
				var mouse_pos = get_global_mouse_position()
				object_detector.visible = true
				object_detector.monitoring = true
				object_detector.global_position = mouse_pos
			#stop delete objects
			if Input.is_action_just_released("mouse_right"):
				object_detector.monitoring = false
				object_detector.visible = false
				mouse_cursor.visible = true
				
		elif current_tile_id != null: #tiles
			if Input.is_action_pressed("mouse_left"):
				place_tiles(set_tilemap(), current_tile_id)
			if Input.is_action_pressed("mouse_right"):
				remove_tiles(set_tilemap())

func set_tilemap():
	if current_item_type == type.PATHS:
		return paths
	if current_item_type == type.DECORATION:
		return decoration
	if current_item_type == type.HILLS:
		return hills
	if current_item_type == type.COLLISIONS:
		return collisions
	if current_item_type == type.BUILDINGS:
		return buildings
	if current_item_type == type.FOLLIAGE_SHADOWS:
		return folliage_shadows
	if current_item_type == type.FOLLIAGE:
		return folliage

func place_tiles(tilemap, tile_id):
	mouse_cursor.texture = null
	var mousepos = tilemap.world_to_map(get_global_mouse_position())
	brush_paint(tilemap, mousepos, tile_id)

func remove_tiles(tilemap):
	mouse_cursor.texture = null
	var mousepos = tilemap.world_to_map(get_global_mouse_position())
	brush_paint(tilemap, mousepos, -1)

func brush_paint(tilemap, mousepos, tile_id):
	if brush_size == 1:
		set_tile(tilemap, mousepos, tile_id, Vector2(0, 0))
	elif brush_size == 2:
		set_tile(tilemap, mousepos, tile_id, Vector2(0, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(0, -1))
		set_tile(tilemap, mousepos, tile_id, Vector2(0, +1))
		set_tile(tilemap, mousepos, tile_id, Vector2(-1, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(+1, 0))
	elif brush_size == 3:
		set_tile(tilemap, mousepos, tile_id, Vector2(0, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(0, -1))
		set_tile(tilemap, mousepos, tile_id, Vector2(0, +1))
		set_tile(tilemap, mousepos, tile_id, Vector2(-1, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(+1, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(1, -1))
		set_tile(tilemap, mousepos, tile_id, Vector2(-1, 1))
		set_tile(tilemap, mousepos, tile_id, Vector2(1, 1))
		set_tile(tilemap, mousepos, tile_id, Vector2(2, 0))
		set_tile(tilemap, mousepos, tile_id, Vector2(2, 1))
		set_tile(tilemap, mousepos, tile_id, Vector2(0, 2))
		set_tile(tilemap, mousepos, tile_id, Vector2(1, 2))

func set_tile(tilemap, mousepos, tile_id, offset : Vector2):
	tilemap.set_cell(mousepos.x + offset.x, mousepos.y + offset.y, tile_id)
	tilemap.update_bitmask_area(Vector2(mousepos.x + offset.x, mousepos.y + offset.y))

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				editor_camera.zoom -= Vector2(0.1, 0.1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				editor_camera.zoom += Vector2(0.1, 0.1)
	if event is InputEventMouseMotion:
		if is_panning:
			editor_camera_container.global_position -= event.relative * editor_camera.zoom
	
	if event.is_action_pressed("brush_1"):
		brush_size = 1
	if event.is_action_pressed("brush_2"):
		brush_size = 2
	if event.is_action_pressed("brush_3"):
		brush_size = 3

func save_level():
	var ui = load("res://UI/UI.tscn")
	var lighting = load("res://Lighting/Lighting.tscn")
	
	#add ui and lighting
	level.add_child(ui.instance())
	level.add_child(lighting.instance())
	
	var to_save : PackedScene = PackedScene.new()
	
	#change all owners
	for i in level.get_children():
		i.owner = level
	
	var tilesets = level.get_node("Tilesets")
	for i in tilesets.get_children():
		i.owner = level
	level.get_node("Tilesets/Hills/Ramps").owner = level
	
	var world = level.get_node("World")
	for i in world.get_children():
		i.owner = level
	
	var checkpoints = world.get_node("Checkpoints")
	for i in checkpoints.get_children():
		i.owner = level
	
	var houses = world.get_node("Houses")
	for i in houses.get_children():
		i.owner = level
	
#	var houses_roofs = houses.get_node("HouseRoofs")
#	for i in houses_roofs.get_children():
#		i.owner = level
#
#	var houses_floors = houses.get_node("HouseFloors")
#	for i in houses_floors.get_children():
#		i.owner = level
#
#	var houses_doors = houses.get_node("HouseDoors")
#	for i in houses_doors.get_children():
#		i.owner = level
	
	var entities = world.get_node("Entities")
	for i in entities.get_children():
		i.owner = level
	
	var characters = entities.get_node("Characters")
	for i in characters.get_children():
		i.owner = level
	
	var player = characters.get_node("Player")
	player.get_node("RemoteTransform2D").owner = level
	
	var items_drop = world.get_node("ItemsDrop")
	for i in items_drop.get_children():
		i.owner = level
	
	var environment = world.get_node("Environment")
	for i in environment.get_children():
		i.owner = level
	
	var objects = world.get_node("Objects")
	for i in objects.get_children():
		i.owner = level
	
	var scene_changer_triggers = world.get_node("SceneChangerTriggers")
	for i in scene_changer_triggers.get_children():
		i.owner = level
	
	var parallax_background = level.get_node("ParallaxBackground")
	for i in parallax_background.get_children():
		i.owner = level
	
	var parallax_layer = parallax_background.get_node("ParallaxLayer")
	for i in parallax_layer.get_children():
		i.owner = level
	
	var _value = to_save.pack(level)
	_value = ResourceSaver.save(popup.current_path + ".tscn", to_save)
	
	level.get_node("UI").queue_free()
	level.get_node("Lighting").queue_free()

func open_level():
	var to_load : PackedScene = PackedScene.new()
	to_load = ResourceLoader.load(popup.current_path)
	var this_level = to_load.instance()
	get_parent().remove_child(level)
	level.queue_free()
	get_parent().get_node("Edit").add_child(this_level)
	level = this_level
	paths = level.get_node("Paths")
	decoration = level.get_node("Decoration")
	collisions = level.get_node("Collisions")
#	world = level.get_node("World")
	folliage_shadows = level.get_node("FolliageShadows")
	folliage = level.get_node("Folliage")

func _on_FileDialog_confirmed():
	if popup.window_title == "Save a File":
		save_level()
	else:
		open_level()

func _on_FileDialog_hide():
	file_system_shown = false
	do_save = false

func _on_ObjectDetector_body_entered(body):
	if body != TileMap:
		var parent = body.get_owner()
		if parent != TileMap:
			if parent == null: #this is a character/ enemy
				body.queue_free()
			else: #this is an object
				parent.queue_free()


