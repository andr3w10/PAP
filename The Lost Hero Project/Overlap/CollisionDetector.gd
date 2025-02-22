extends Node2D

onready var MAX_LENGTH = 15
onready var rayCast2D = $RayCast2D
onready var parent = get_parent()

var point : Vector2

func _physics_process(delta):
	var player_position = Globals.player.global_position - global_position
	var max_cast_to = player_position.normalized() * MAX_LENGTH
	rayCast2D.cast_to = max_cast_to
	if rayCast2D.is_colliding():
		if rayCast2D.cast_to.x > rayCast2D.cast_to.y:
			point = Vector2(rayCast2D.cast_to.x * -1, rayCast2D.cast_to.y)
		else:
			point = Vector2(rayCast2D.cast_to.x, rayCast2D.cast_to.y * -1)
		get_node("RayCast2D2").cast_to = point
