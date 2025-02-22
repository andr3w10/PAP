extends "res://AI/AIRaycasts.gd"

#export (Array, Array, Vector2) var path_points
var follow_path = false
var show_path = true
var follow_player = false
var detect_player = true
var talk_to_player = true
var player_is_near = false

var current_path = 1
var current_points = []
var current_point_idx = 0

export (String) var npc_name = ""
export (Array, int) var default_dialogue_idx

func _apply_follow_path_velocity():
	get_node("Event").show_label = false
	if current_points == []:
		#get points
		var path_node = Globals.map.npc_paths.get_node(str(current_path))
		var count = path_node.curve.get_point_count()
		for i in range(count):
			current_points.append(path_node.curve.get_point_position(i))
		
		current_point_idx = 0
		
	else:
		if current_point_idx == current_points.size():
			current_points = []
			spawn_position = global_position
			follow_path = false
			return
		move_towards(current_points[current_point_idx])
		if (current_points[current_point_idx] - global_position).length() < 2:
			current_point_idx += 1
		
		if velocity.x < 0 && animation_player.has_animation("runLeft"):
			animation_player.play("runLeft")
		elif velocity.x >= 0 && animation_player.has_animation("runRight"):
			animation_player.play("runRight")

func get_dialogue_idx():
	if follow_path:
		return null
	
	for i in range(NpcDialogue.npc_dialogue[npc_name].size()):
		if NpcDialogue.npc_dialogue[npc_name][i][1] == false:
#			if !NpcDialogue.npc_dialogue[npc_name].has(i+1):
#				get_node("Event").show_label = false
			return i
	
	#default dialogue
#	return (NpcDialogue.npc_dialogue[npc_name].size() - 1)
	var rand_dialogue = (randi() % default_dialogue_idx.size()) + 1
	rand_dialogue = rand_dialogue - 1 #delete the offset
	return (default_dialogue_idx[rand_dialogue])

func completed_dialogue(idx):
	NpcDialogue.npc_dialogue[npc_name][idx][1] = true

func is_near_player():
	if talk_to_player:
		talk_to_player = false
		follow_player = false
		get_node("Event")._on_EventTrigger_triggered()
		follow_path = true


func _on_PlayerDetector_body_entered(body):
	if body == Globals.player:
		player_is_near = true
		if detect_player:
			detect_player = false
			follow_player = true


func _on_PlayerDetector_body_exited(body):
	if body == Globals.player:
		player_is_near = false


func _on_path_completed():
	get_node("Event").show_label = true
	if show_path:
		show_path = false
		get_node("Event")._on_EventTrigger_triggered()
