extends Node2D

onready var top_collision = $Collision/TopCollision
onready var bottom_collision = $Collision/BottomCollision

export var bridge_zindex : int = 0

func _ready():
	#set z_index
	z_index = bridge_zindex
	for i in get_children():
		i.z_index = bridge_zindex

func _on_RemoveCollision_body_entered(body):
	if body.z_index == bridge_zindex:
		body.set_collision_mask_bit(0, false)

func _on_RemoveCollision_body_exited(body):
	if body.z_index == bridge_zindex:
		body.set_collision_mask_bit(0, true)

func _on_CharacterCheck_body_entered(body):
	if body.z_index == bridge_zindex:
		body.set_collision_mask_bit(2, true)

func _on_CharacterCheck_body_exited(body):
	if body.z_index == bridge_zindex:
		body.set_collision_mask_bit(2, false)
