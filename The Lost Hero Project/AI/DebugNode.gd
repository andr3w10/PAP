extends Node2D


export var enableDebug := true

export var rayLineSize := 1.0
export var rayLenMultiplier := 1.0
export var rayDefaultColor := Color.green
export var rayCollisionColor := Color.red
export var rayDisabledColor := Color.darkgray

var path := [] # Vector2
var rays := [] # {'start': Vector2, 'end': Vector2, 'enabled': bool, 'collided': bool}


func _process(_delta) -> void:
	if enableDebug:
		self.update()
	elif !rays.empty():
		rays.clear()
		self.update()


func _draw() -> void:
	if ! rays.empty():
		_drawRays()


func _drawRays() -> void:
	var color := rayDefaultColor
	var size := rayLineSize
	for ray in rays:
		if ray is RayCast2D:
			var start = ray.position
			var end = start + ray.cast_to.rotated(ray.rotation) * rayLenMultiplier
			if ! ray.enabled:
				color = rayDisabledColor
			elif ray.is_colliding():
				color = rayCollisionColor
			self.draw_line(start, end, color, size)
		else:
			var start = ray['start']
			var end = start + (ray['end'] - start) * rayLenMultiplier
			if ray['enabled'] == false:
				color = rayDisabledColor
			elif ray['collided'] == true:
				color = rayCollisionColor
			self.draw_line(start, end, color, size)

