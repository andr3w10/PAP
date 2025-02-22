extends "res://Characters/Character.gd"

export var debugNodePath := @''

var _debugNode : Node2D = null
var delta : float

func _ready() -> void:
	if ! debugNodePath.is_empty():
		_debugNode = self.get_node(debugNodePath)

func _physics_process(_delta) -> void:
	delta = _delta
	if _debugNode:
		_debugNode.rays = _getRayPoints()

func move_towards(to):
#	var target = weakref(get_target())
	var dir := _findMoveDirection(to)
	var avoidance = get_avoidance()
	var direction = dir + avoidance
	velocity = lerp(velocity, direction * move_speed * 24, get_move_weight())

func _findMoveDirection(target_position : Vector2) -> Vector2:
	var dir := (target_position - self.global_position).normalized()
	return dir

func _getRayPoints() -> Array:
	return []
