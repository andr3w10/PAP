extends Control

onready var time_label = $Time
onready var am_pm = $AmPm
onready var day_label = $Day
onready var year_label = $Year

func _process(_delta):
	#to set the hour properly
	if DateTime.hour < 13:
		am_pm.text = "am"
		#to set the minutes properly
		if DateTime.minute < 10:
			time_label.text = str(DateTime.hour) + ":0" + str(DateTime.minute)
		else:
			time_label.text = str(DateTime.hour) + ":" + str(DateTime.minute)
	else:
		am_pm.text = "pm"
		#to set the minutes properly
		if DateTime.minute < 10:
			time_label.text = str((DateTime.hour) - 12) + ":0" + str(DateTime.minute)
		else:
			time_label.text = str((DateTime.hour) - 12) + ":" + str(DateTime.minute)

	day_label.text = "DAY " + str(DateTime.day)
	year_label.text = "YEAR " + str(DateTime.year)
