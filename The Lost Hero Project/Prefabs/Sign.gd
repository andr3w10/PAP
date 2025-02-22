extends "res://Events/Event.gd"

export (String) var id = "000"

onready var sprite = $Sprite

func _ready():
	var rnd = int(rand_range(1, 3))
	var path = "res://PixelArt/Prefabs/Signs/default_sign" + str(rnd) + ".png"
	sprite.texture = load(path)

func register_events():
	var _value
	_value = connect("event_triggered", Globals.map.ui.dialogue_manager, "init_dialogue", [])

func _on_EventTrigger_triggered():
#	animation_player.play("open_chest")
#	yield(animation_player, "animation_finished")
	get_tree().paused = true
	Globals.can_open_menu = false
	emit_signal("event_triggered", id)
	yield(Globals.map.ui.dialogue_manager, "finished")
	get_tree().paused = false
#	animation_player.play("close_chest")
	Globals.can_open_menu = true
