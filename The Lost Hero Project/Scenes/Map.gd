extends Node2D

enum Types {NORMAL, CAVE, DUNGEON}

export (String) var map_name = ""
export (String) var map_path_name = ""
export (Types) var map_type = 0
export (bool) var show_name = true
export (bool) var boss_fight = false

onready var characters = $World/Entities/Characters
onready var entities = $World/Entities

#onready var ground = $Tilesets/Ground

onready var ui = $UI

onready var npc_paths = $NPC_Paths


var farm : TileMap

func _ready():
	AudioPlayer.play_background()
	
	var debug_ui = load("res://UI/Debug/DebugUI.tscn").instance()
	debug_ui.add_stat("Entities Count", self, "get_entities_count", true)
	add_child(debug_ui)
	
	Globals.map = self
	
	update_chests_texture()
	
	map_loaded()
	
	if show_name:
		ui.top_text_display.show_text(map_name)
	
	if map_type != 0:
		Globals.change_light = false
		DateTime.change_night()
		Globals.player.get_node("LightSource").radius = 120
	else:
		Globals.change_light = true

func get_entities_count():
	var num = -1
	for i in get_node("World/Entities").get_children():
		num += 1
	for i in get_node("World/Entities/Characters").get_children():
		num += 1
	return num

func add_character(character):
	characters.add_child(character)
	
func add_entity(entity):
	entities.add_child(entity)

func map_loaded():
	get_tree().call_group("Events", "register_events")
	get_tree().call_group("SceneChangerTriggers", "show")

func update_chests_texture():
	var chests = get_tree().get_nodes_in_group("Chests")
	var id = "000"
	for i in chests:
		id = i.id
		for j in chests:
			if j != i && j.id == id:
				i.change_texture(true)


##need to be careful with packed scenes
#func change_owners(node, owner_node):
#	var childs = node.get_children()
#	if childs != null:
#		for i in childs:
#			i.owner = owner_node
#			change_owners(i, owner_node)


##canceld
#func get_map_changes():
#	var scene = PackedScene.new()
#
#	var level = self
#
#
#	#change all owners
#	for i in level.get_children():
#		i.owner = level
#
#	var tilesets = level.get_node("Tilesets")
#	for i in tilesets.get_children():
#		i.owner = level
#	level.get_node("Tilesets/Hills/Ramps").owner = level
#	for i in level.get_node("Tilesets/Hills/Ramps").get_children():
#		i.owner = level
#
#	var world = level.get_node("World")
#	for i in world.get_children():
#		i.owner = level
#
#	var bridges = world.get_node("Bridges")
#	for i in bridges.get_children():
#		i.owner = level
#
#	var checkpoints = world.get_node("Checkpoints")
#	for i in checkpoints.get_children():
#		i.owner = level
#
#	var houses = world.get_node("Houses")
#	for i in houses.get_children():
#		i.owner = level
#
##	var houses_roofs = houses.get_node("HouseRoofs")
##	for i in houses_roofs.get_children():
##		i.owner = level
##
##	var houses_floors = houses.get_node("HouseFloors")
##	for i in houses_floors.get_children():
##		i.owner = level
##
##	var houses_doors = houses.get_node("HouseDoors")
##	for i in houses_doors.get_children():
##		i.owner = level
#
#	var entities = world.get_node("Entities")
#	for i in entities.get_children():
#		i.owner = level
#
#	var characters = entities.get_node("Characters")
#	for i in characters.get_children():
#		i.owner = level
#
#	var player = characters.get_node("Player")
#	player.get_node("RemoteTransform2D").owner = level
#
#	var items_drop = world.get_node("ItemsDrop")
#	for i in items_drop.get_children():
#		i.owner = level
#
#	var environment = world.get_node("Environment")
#	for i in environment.get_children():
#		i.owner = level
#
#	var objects = world.get_node("Objects")
#	for i in objects.get_children():
#		i.owner = level
#
#	var scene_changer_triggers = world.get_node("SceneChangerTriggers")
#	for i in scene_changer_triggers.get_children():
#		i.owner = level
#		for j in i.get_children():
#			i.owner = level
#
#	var parallax_background = level.get_node("ParallaxBackground")
#	for i in parallax_background.get_children():
#		i.owner = level
#
#	var parallax_layer = parallax_background.get_node("ParallaxLayer")
#	for i in parallax_layer.get_children():
#		i.owner = level
#
#
#
#	scene.pack(level)
#
#	return scene
