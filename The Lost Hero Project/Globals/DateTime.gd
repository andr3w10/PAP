extends Node

signal change_day
signal change_night
signal change_day_night
signal change_night_day

signal new_day_start
var sended_new_day_signal = false

var TIME_SPEED : float = 100.0
const INITIAL_TIME = 36000 #10:00am -> 36000 | 6:00am -> 21000 (1 hour = 3600)

var time = INITIAL_TIME

var minute = 0
var hour = 0
var day = 0
var year = 0

func _ready():
	pause_mode = self.PAUSE_MODE_PROCESS
	
	var int_time = int(floor(time))
	minute = (int_time / 60) % 60
	hour = (int_time / (60 * 60)) % 24
	day = (int_time / (60 * 60 * 24)) % 365
	year = (int_time / (60 * 60 * 24 * 365))

func _process(delta):
	time += delta * TIME_SPEED
	var int_time = int(floor(time))
	
	minute = (int_time / 60) % 60
	hour = (int_time / (60 * 60)) % 24
	day = (int_time / (60 * 60 * 24)) % 365
	year = (int_time / (60 * 60 * 24 * 365))
	
	if hour == 0:
		if !sended_new_day_signal:
			emit_signal("new_day_start")
			sended_new_day_signal = true
	else:
		if sended_new_day_signal:
			sended_new_day_signal = false
	
	if Globals.change_light:
		if hour >= 20 || hour <= 5:
			emit_signal("change_night")
		elif hour >= 7 && hour <= 18:
			emit_signal("change_day")
		elif hour == 6:
			emit_signal("change_night_day")
		elif hour == 19:
			emit_signal("change_day_night")

func change_night():
	emit_signal("change_night")

func change_day():
	emit_signal("change_day")
