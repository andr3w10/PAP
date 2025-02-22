extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()
onready var shake_tween = get_node("ShakeTween")
onready var frequency = get_node("Frequency")
onready var duration = get_node("Duration")

var amplitude = 0
var priority = 0

func _ready():
	var _value
	_value = PlayerStats.connect("player_damaged", self, "start")

func start(duration_value = 0.2, frequency_value = 15, amplitude_value = 16, priority_value = 0):
	if priority_value >= priority:
		priority = priority_value
		amplitude = amplitude_value
		
		duration.wait_time = duration_value
		frequency.wait_time = 1 / float(frequency_value)
		duration.start()
		frequency.start()
		
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	shake_tween.interpolate_property(camera, "offset", camera.offset, rand, frequency.wait_time, TRANS, EASE)
	shake_tween.start()

func _reset():
	shake_tween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequency.wait_time, TRANS, EASE)
	shake_tween.start()
	priority = 0

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	frequency.stop()
