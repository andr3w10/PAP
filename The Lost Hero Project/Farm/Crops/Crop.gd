extends "res://Farm/Plant.gd"


var phase_days = []

export var crop_data = {"type": 1,
				"object_name": "",
				"phase_days": [1, 1, 1, INF],
				"current_phase": 0,
				"day_of_current_phase": 0,
				"crop_age": 0}

func _ready():
	var _value = DateTime.connect("new_day_start", self, "_on_new_day_start")
	check_plant_status(phase_days)

func initialize(data):
	.initialize(data)
	phase_days = data.get("phase_days")
	
	$AnimationPlayer.play(str(current_phase))

func _on_new_day_start():
	crop_age += 1
	day_of_current_phase += 1
	check_plant_status(phase_days)
