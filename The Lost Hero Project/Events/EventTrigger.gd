extends Area2D
class_name EventTrigger

signal triggered

func on_triggered():
	emit_signal("triggered")
