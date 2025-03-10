extends Node

const END_VALUE = 1

var is_active = false
var time_start
var duration_ms
var start_value

func _ready():
	var _value
	_value = PlayerStats.connect("player_damaged", self, "start")

func start(duration = 0.2, strength = 0.9):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strength
	Engine.time_scale = start_value
	is_active = true

func _process(_delta):
	if is_active:
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
		Engine.time_scale = value

#t: curent time
#b: start time
#c: end value
#d: duration
func circl_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) -  1) + b
