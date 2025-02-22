extends Node2D

export var z_low :int = 0
export var z_up :int = 20

func _on_RemoveCollision_body_entered(body):
	body.set_collision_mask_bit(0, false)

func _on_RemoveCollision_body_exited(body):
	body.set_collision_mask_bit(0, true)


func _on_ZLow_body_entered(body):
	body.set_collision_mask_bit(2, false)
	body.z_index = z_low

func _on_ZUp_body_entered(body):
	body.set_collision_mask_bit(2, true)
	body.z_index = z_up
