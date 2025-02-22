extends Control

export (Gradient) var gradient

onready var tween = $Tween
onready var bar = $BossHealthBarUI
onready var bar_under = $BossHealthBarUIunder

func _ready():
	_on_BossHealthBarUI_value_changed(bar.value)

func _on_BossHealthBarUI_value_changed(_new_value):
	bar.tint_progress = gradient.interpolate(bar.ratio)

func change_boss_name(name):
	var new = ""
	for i in name:
		new += i
		if i == " ":
			new += i
			new += i
	
	$Label.text = new
	

#(new_value * 10) to make the animation

func set_max_health(new_value):
	bar.max_value = (new_value * 10)
	bar_under.max_value = (new_value * 10)

func set_health(new_value):
	bar.value = (new_value * 10)
	tween.stop_all()
	tween.interpolate_property(bar_under, "value", bar_under.value, (new_value * 10), 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	tween.start()
