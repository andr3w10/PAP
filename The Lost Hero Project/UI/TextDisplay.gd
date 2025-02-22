extends Control

onready var tween = $Tween
onready var label = $Label
onready var timer = $Timer

func show_text(text : String, duration : float = 5.0, transition_time : float = 0.8, font_size : int = 25):
	self.visible = true
	var font = label.get("custom_fonts/font")
	font.size = font_size
	label.text = text
	timer.start(duration)
	tween.interpolate_property(label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(timer, "timeout")
	tween.interpolate_property(label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	self.visible = false
