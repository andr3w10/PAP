extends "res://AI/AI.gd"

var exclusions = []

var active_ai :bool= true

class Ray:
	var length := 0.0
	var dir := Vector2.ZERO
	var canMove := true
	var playerWeight := 0.0
	var moveonWeight := 0.0

	func _init(_length : float, _dir : Vector2) -> void:
		self.length = _length
		self.dir = _dir

export var raySize := 50
export var rayCount := 40

var _rays := []
var _currentRay : Ray = null

func _ready() -> void:
	var dir := Vector2.RIGHT
	for i in range(0, rayCount):
		var ray := Ray.new(raySize, dir.rotated(i * PI * 2 / rayCount))
		_rays.append(ray)
	_currentRay = _rays[0]

func _findMoveDirection(target_position : Vector2) -> Vector2:
	var vector := target_position - self.global_position

	_updateRays(vector, _currentRay.dir)
	_findRayDirection()

	return _currentRay.dir if _currentRay else Vector2.ZERO

func _updateRays(targetDir : Vector2, moveDir : Vector2) -> void:
	var state := self.get_world_2d().direct_space_state
	for ray in _rays:
		var collision := state.intersect_ray(self.global_position, self.global_position + ray.dir * ray.length, [exclusions], 0x1)
		if collision && active_ai:
			ray.canMove = false
		else:
			ray.canMove = ! self.test_move(self.global_transform, self.move_speed * delta * ray.dir)
		ray.playerWeight = targetDir.dot(ray.dir)
		ray.moveonWeight = moveDir.dot(ray.dir)

func _findRayDirection() -> void:
	var raysSameSide := []
	var raysOtherSide := []
	for ray in _rays:
		if ray.canMove && ray.dir.dot(_currentRay.dir) > 0:
			raysSameSide.append(ray)
		elif ray.canMove:
			raysOtherSide.append(ray)

	if _currentRay.canMove:
		for ray in _rays:
			if ray.canMove && ray.dir.dot(_currentRay.dir) > 0:
				raysSameSide.append(ray)
		for ray in raysSameSide:
			if ray.playerWeight >= _currentRay.playerWeight:
				_currentRay = ray
	else:
		var newRay : Ray = _currentRay
		if ! raysSameSide.empty():
			newRay = raysSameSide[0]
			for ray in raysSameSide:
				if ray.moveonWeight > newRay.moveonWeight:
					newRay = ray
		elif ! raysOtherSide.empty():
			newRay = raysOtherSide[0]
			for ray in raysOtherSide:
				if ray.playerWeight > newRay.playerWeight:
					newRay = ray
		_currentRay = newRay

func _onLostTarget() -> void:
	_currentRay = _rays.front()

func _getRayPoints() -> Array:
	var rays := []
	var usePlayerWeight := true if _currentRay && _currentRay.canMove else false
	for ray in _rays:
		var start := Vector2.ZERO
		var end : Vector2 = ray.dir * ray.length * (ray.playerWeight / 40 if usePlayerWeight else ray.moveonWeight / 5)
		var enabled := true
		var collided : bool = ! ray.canMove
		rays.append({'start': start, 'end': end, 'enabled': enabled, 'collided': collided})
	return rays

