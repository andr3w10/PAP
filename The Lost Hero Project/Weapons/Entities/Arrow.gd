extends KinematicBody2D

export (int) var speed = 10 * 24

onready var damage_area = $DamageArea

var velocity := Vector2()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		destroy()

func set_direction(normal : Vector2):
	if !normal.is_normalized():
		push_error("normal.is_normalized != true")
	
	velocity = normal * speed

func destroy():
	#TODO : Animation
	queue_free()

func _on_Timer_timeout():
	destroy()

func _on_DamageArea_hitteded():
	destroy()
