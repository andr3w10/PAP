extends Node

var max_health
var health
var move_speed

signal health_changed
signal max_health_changed
signal move_speed_changed
signal player_damaged

func _ready():
	pass

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_move_speed(value):
	move_speed = value
	emit_signal("move_speed_changed", move_speed)

func damaged():
	emit_signal("player_damaged")
