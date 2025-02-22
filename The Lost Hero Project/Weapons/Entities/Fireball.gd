extends KinematicBody2D

const SPEED = 4 * 24
const MAX_BOUNCES = 1

var velocity := Vector2()
var bounce = 0

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		bounce += 1
		if bounce >= MAX_BOUNCES:
			destroy()
		velocity = velocity.bounce(collision.normal)

func set_direction(normal : Vector2, damage_group, speed = SPEED):
	var damage_area = get_node("DamageArea")
	if damage_group == "enemy":
		damage_area.set_collision_layer_bit(11, true)
	elif damage_group == "ally":
		damage_area.set_collision_layer_bit(10, true)
	
	if !normal.is_normalized():
		push_error("normal.is_normalized != true")
	
	velocity = normal * speed

func destroy():
	#TODO : animation
	queue_free()

func _on_DamageArea_hitteded():
	destroy()
