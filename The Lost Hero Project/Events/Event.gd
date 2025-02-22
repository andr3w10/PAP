extends Node2D

const outline_material_path = "res://Others/Materials/Outlines/outline.material"

signal event_triggered

export (bool) var active = true

onready var animation_player = $AnimationPlayer
onready var interact_label = $InteractLabel

export (bool) var show_label = true

export (NodePath) var body_sprite_path = null

func _ready():
	pass

func _process(_delta):
	if active:
		if interact_label.visible == true:
			var mouse_pos = get_global_mouse_position()
			interact_label.global_position = mouse_pos + Vector2(0, 12)

func register_events():
	var _value
	_value = connect("event_triggered", self, "_ready", [])

func _on_EventTrigger_triggered():
	if active:
		emit_signal("event_triggered")

func set_outline_shader():
	if body_sprite_path != null:
		var body_sprite = get_node(body_sprite_path)
	
		if body_sprite != null:
			body_sprite.material = load(outline_material_path)

func unset_outline_shader():
	if body_sprite_path != null:
		var body_sprite = get_node(body_sprite_path)
		
		if body_sprite != null:
			body_sprite.material = null
