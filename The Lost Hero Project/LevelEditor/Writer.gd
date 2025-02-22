extends Control

signal advance

func _ready():
	self.visible = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("advance")

func request_id(item):
	get_tree().paused = true
	self.rect_position = get_global_mouse_position()
	self.visible = true
	yield(self, "advance")
	self.visible = false
	get_tree().paused = false
	var id = get_node("LineEdit").text
	item.id = id
	#clean the line
	get_node("LineEdit").text = "000"
	#update textures
	get_parent().get_parent().get_node("Edit/Level").update_chests_texture()
