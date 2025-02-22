extends "res://AI/AIRaycasts.gd"
class_name Pet

const INTERACT_RANGE = 5 * 16

onready var event_trigger = $Event/EventTrigger
onready var sleep_time_label = $sleep_time_left
onready var sit_label = $Event/press_e_to_sit

export (int) var min_distance_to_player = 3 * 16 #x * tile
export (int) var max_distance_to_player = 15 * 16 #x * tile

export (String) var pet_name = ""

var my_owner = null
var is_sleeping : bool = false
var is_mouse_over : bool = false

func _ready():
	var _value
	_value = event_trigger.connect("triggered", self, "sleep")

func _apply_sleep_velocity():
	sleep_time_label.text = str(int(sleep_timer.time_left))
	
	if !animation_player.is_playing():
		if velocity.x < 0 && animation_player.has_animation("sleepLeft"):
			animation_player.play("sleepLeft")
		elif velocity.x >= 0 && animation_player.has_animation("sleepRight"):
			animation_player.play("sleepRight")
			
	velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _process(_delta):
	if is_sleeping == false:
		my_owner = get_player()
		if my_owner != null && (my_owner.pet == null || my_owner.pet == self):
			if get_player(max_distance_to_player - 6) == null && my_owner.pet == self:
				remove_stats()
				my_owner.pet = null
				return
			my_owner.pet = self
			give_stats()
	
	if get_node("Event/InteractLabel").visible == true:
		get_node("Event/InteractLabel").visible = false

func is_near_to_player() -> bool:
	var target = get_player()
	if target == null:
		return false
	
	var distance = (target.global_position - global_position).length()
	return distance < min_distance_to_player

func get_player(max_distance = max_distance_to_player):
	var nearest_player = null
	if Globals.map.map_name != "LevelEditor":
		var distance = max_distance
		var characters = Globals.map.characters
		for character in characters.get_children():
			if character.get_name() == "Player":
				var this_distance = (character.global_position - global_position).length()
				if this_distance < distance:
					nearest_player = character
					distance = this_distance
	return nearest_player

#virtual method, because dont exist a default stat to give
func give_stats():
	pass

#virtual method, because dont exist a default stat to remove
func remove_stats():
	pass

func sleep():
	if my_owner != null:
		if my_owner.pet == self:
			if !is_sleeping:
				remove_stats()
				sit_label.visible = false
				sleep_time_label.visible = true
				sleep_timer.start()
				is_sleeping = true
				my_owner.pet = null

func _on_SleepTimer_timeout():
	sleep_time_label.visible = false
	
	if velocity.x < 0 && animation_player.has_animation("goSleepLeft"):
		animation_player.play_backwards("goSleepLeft")
		yield(animation_player, "animation_finished")
	elif velocity.x >= 0 && animation_player.has_animation("goSleepRight"):
		animation_player.play_backwards("goSleepRight")
		yield(animation_player, "animation_finished")
	
	is_sleeping = false

func update_sit_label():
	if sit_label.visible == true:
		var mouse_pos = get_global_mouse_position()
		sit_label.global_position = mouse_pos + Vector2(0, 12)
