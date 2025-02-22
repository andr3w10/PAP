extends "res://Characters/Enemies/Enemy.gd"

const BASE_PREPARE_TIME = 1.6

onready var fire_point = $Body/Pivot/FirePoint

func attack():
	var target = get_target()
	if target != null:
		var fireball = preload("res://Weapons/Entities/Fireball.tscn").instance()
		var normal = (target.global_position - fire_point.global_position).normalized()
		fireball.set_direction(normal, "ally")
		Globals.map.add_entity(fireball)
		fireball.global_position = fire_point.global_position
		animation_player.play("attack")

func is_attacking():
	return !animation_player.is_playing()

func prepare_attack():
	prepare_timer.start(BASE_PREPARE_TIME + rand_range(-0.6, 0.6))
