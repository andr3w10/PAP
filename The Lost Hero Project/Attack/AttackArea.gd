extends Node2D

onready var damage_area = $DamageArea

func set_attacker(attacker):
	damage_area.attacker = attacker

func _on_Timer_timeout():
	#TO DO: animation
	queue_free()
