extends Node2D

onready var damage_area = get_node("DamageArea")
onready var preview_timer = get_node("PreviewTimer")
onready var animation_player = get_node("AnimationPlayer")
onready var preview_sprite = get_node("Preview")

var attacker = null

func attack(damage_group, attacker_character, show_preview, preview_time := 3.0):
	attacker = attacker_character
	
	if damage_group == "enemy":
		damage_area.set_collision_layer_bit(11, true)
	elif damage_group == "ally":
		damage_area.set_collision_layer_bit(10, true)
	else:
		push_error("You need to set the attacker of water area!")
		return
	
	if show_preview:
		preview_sprite.visible = true
		preview_timer.start(preview_time)
		yield(preview_timer, "timeout")
		preview_sprite.visible = false
	
	animation_player.play("water_splash")


func _on_animation_finished():
	if attacker != null:
		attacker._water_splash_completed()
	
	queue_free()
