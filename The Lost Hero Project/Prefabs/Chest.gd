extends "res://Events/Event.gd"

const DEFAULT_TEXTURE = preload("res://PixelArt/Prefabs/chest.png")
const ENCHANTED_TEXTURE = preload("res://PixelArt/Prefabs/enchanted_chest.png")

signal close_chest

export (String) var id = "000"

onready var sprite = $Sprite

var is_opened = false
var is_shared = false

func _ready():
	change_texture(false)

func register_events():
	var _value
	_value = connect("event_triggered", Globals.map.ui.chest_ui, "init_chest", [])
	_value = connect("close_chest", Globals.map.ui.chest_ui, "close_chest")

func _on_EventTrigger_triggered():
	if !is_opened:
		is_opened = true
		Globals.can_open_menu = false
		animation_player.play("open_chest")
		yield(animation_player, "animation_finished")
		get_tree().paused = true
		emit_signal("event_triggered", id)

func _unhandled_input(event):
	if (event.is_action_pressed("menu") || event.is_action_pressed("ui_accept")) && self.visible && is_opened:
		get_tree().paused = false
		is_opened = false
		Globals.can_open_menu = true
		animation_player.play("close_chest")
		emit_signal("close_chest")

func change_texture(enchanted : bool):
	if enchanted:
		sprite.texture = ENCHANTED_TEXTURE
	else:
		sprite.texture = DEFAULT_TEXTURE
