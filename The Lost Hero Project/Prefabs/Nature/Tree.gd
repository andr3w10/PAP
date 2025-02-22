extends StaticBody2D

onready var tween = $Tween
onready var sprite = $Sprite

var fade_time = 0.1

func _on_Area2D_body_entered(_body):
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.6), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _on_Area2D_body_exited(_body):
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 0.6), Color(1, 1, 1, 1), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
