extends Node2D

const FIRST_MAP_SAVE = "res://Scenes/Levels/"

enum Elements {Fire, Water, Grass, Earth, Thunder, Wind, Light, Psychic, Shadow}

export (Texture) var orb_tex
export (Elements) var element

export(String) var next_scene_path_name = ""
export(Vector2) var player_next_scene_spawn_position = Vector2.ZERO

onready var animation_player = $AnimationPlayer

var can_interact = true

func _ready():
	if PlayerInventory.spells[element][1] == 1:
		Globals.current_boss.queue_free()
		get_node("Event/InteractLabel").visible = false
		can_interact = false
		get_node("Event").show_label = false
		get_node("orb").visible = false
	
	get_node("orb").texture = orb_tex

func _on_EventTrigger_triggered():
	if can_interact:
		if Globals.current_boss != null:
			Globals.current_boss.start_boss_fight(self)
			get_node("Event/InteractLabel").visible = false
			can_interact = false
			get_node("Event").show_label = false
		else:
			PlayerInventory.spells[element][1] = 1
			get_node("Event/InteractLabel").visible = false
			can_interact = false
			get_node("Event").show_label = false
			get_node("orb").visible = false
			if next_scene_path_name != "":
				var next_scene_path = ""
				next_scene_path = FIRST_MAP_SAVE + next_scene_path_name + ".tscn"
				Globals.player_initial_position = player_next_scene_spawn_position
				SceneChanger.change_the_scene(next_scene_path, .5)

func boss_defeated():
	can_interact = true
	animation_player.play("show_orb")
	get_node("Event/InteractLabel").visible = true
	get_node("Event").show_label = true
