extends Node2D

onready var damage_area = get_node("DamageArea")
onready var animation_player = get_node("AnimationPlayer")

var attacker = null

func attack(damage_group, attacker_character, size):
	attacker = attacker_character
	
	if damage_group == "enemy":
		damage_area.set_collision_layer_bit(11, true)
	elif damage_group == "ally":
		damage_area.set_collision_layer_bit(10, true)
	else:
		push_error("You need to set the attacker of water area!")
		return
	
	match size:
		0:
			animation_player.play("shockwave_0")
		1:
			animation_player.play("shockwave_1")
		2:
			animation_player.play("shockwave_2")
		3:
			animation_player.play("shockwave_3")


func _on_animation_finished():
	if attacker != null:
		attacker._shockwave_completed()
	
	queue_free()
