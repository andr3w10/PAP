extends Area2D
class_name DamageArea

signal hitteded()

export var damage_amount : int = 1
export var knockback_strength : int = 2
export var use_exceptions : bool = false
#FIXME: keep the reference of the attacker (ex: if enemy dies after shoot an arrow, tha arrow should keep in the world)
export (NodePath) var attacker = null

var exceptions = []

func _ready():
	if attacker != null:
		attacker = get_node_or_null(attacker)

func on_hit(hitbox):
	if use_exceptions:
		exceptions.append(hitbox)
	emit_signal("hitteded")
