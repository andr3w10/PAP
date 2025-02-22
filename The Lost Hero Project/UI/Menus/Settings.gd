extends Control

export (NodePath) var fullscreen_btn

var detect = true

func _ready():
	detect = false
	if OS.window_fullscreen == true:
		get_node(fullscreen_btn).pressed = true
	else:
		get_node(fullscreen_btn).pressed = false
	detect = true

func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)

func _on_Interface_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Interface"), value)

func _on_Fullscreen_toggled(_button_pressed):
	if detect:
		OS.window_fullscreen = !OS.window_fullscreen
