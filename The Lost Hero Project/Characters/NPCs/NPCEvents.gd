extends "res://Events/Event.gd"

func register_events():
	var _value
	_value = connect("event_triggered", Globals.map.ui.dialogue_manager, "init_dialogue", [])

func _on_EventTrigger_triggered():
	var idx = get_parent().get_dialogue_idx()
	if idx != null:
		var dialogue_idx = NpcDialogue.npc_dialogue[get_parent().name][idx][0]
		
	#	animation_player.play("open_chest")
	#	yield(animation_player, "animation_finished")
		get_tree().paused = true
		Globals.can_open_menu = false
		emit_signal("event_triggered", dialogue_idx)
		yield(Globals.map.ui.dialogue_manager, "finished")
		
		#add to done_dialogue
		get_parent().completed_dialogue(idx)
		
		get_tree().paused = false
	#	animation_player.play("close_chest")
		Globals.can_open_menu = true
