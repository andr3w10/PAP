extends "res://Events/Event.gd"

func register_events():
	var _value
	_value = connect("event_triggered", Globals.map.ui.pethouse_ui, "open_menu")

func _on_EventTrigger_triggered():
	emit_signal("event_triggered")
