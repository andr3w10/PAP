extends Area2D

signal damaged(amount, knockback_strength, damage_scource, attacker)
#signal immunity_started()
signal immunity_ended()

onready var immunity_timer = $ImmunityTimer
onready var parent = get_parent()

export var immunity_duration : float = 0.0

var exceptions = []

func add_exception(node : Node2D):
	var _value
	if node != null:
		exceptions.append(node)
		_value = node.connect("tree_exiting", self, "remove_exception", [node])
		
func remove_exception(node : Node2D):
	if node in exceptions:
		exceptions.erase(node)

func _on_Hitbox_area_entered(area):
	if area in exceptions || !immunity_timer.is_stopped():
		return
	
	if area is DamageArea:
		#TO DO: add immunity
		if !(self in area.exceptions):
			damage(area.damage_amount, area.knockback_strength, area, area.attacker)
			area.on_hit(self)
			
func damage(amount, knockback, scource, attacker):
	emit_signal("damaged", amount, knockback, scource, attacker)
	if immunity_duration > 0:
		immunity_timer.start(immunity_duration)


func _on_ImmunityTimer_timeout():
	emit_signal("immunity_ended")
