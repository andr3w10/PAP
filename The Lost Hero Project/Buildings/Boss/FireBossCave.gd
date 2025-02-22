extends "res://Events/Event.gd"

const ENTER_CAVE_ID = "1000"
const player_next_scene_spawn_position = Vector2(157, 770)
const boss_cave_scene_path = "res://Scenes/Levels/FireElementRoom.tscn"

func register_events():
	var _value
	_value = connect("event_triggered", Globals.map.ui.dialogue_manager, "init_dialogue", [])
	Globals.map.ui.dialogue_manager.connect_signal("accepted", self, "enter_cave")

func _process(_delta):
	if PlayerInventory.spells[0][1] == 1:
		if get_node("InteractLabel").visible == true:
			get_node("InteractLabel").visible = false

func _on_EventTrigger_triggered():
	if PlayerInventory.spells[0][1] == 0:
	#	animation_player.play("open_chest")
	#	yield(animation_player, "animation_finished")
		get_tree().paused = true
		Globals.can_open_menu = false
		emit_signal("event_triggered", ENTER_CAVE_ID)
		yield(Globals.map.ui.dialogue_manager, "finished")
		get_tree().paused = false
	#	animation_player.play("close_chest")
		Globals.can_open_menu = true

func enter_cave():
	Globals.player_initial_position = player_next_scene_spawn_position
	SceneChanger.change_the_scene(boss_cave_scene_path, 0)
