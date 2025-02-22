extends Position2D
class_name LightSource

export var color := Color("#ffd0a6")
export var radius := 60
export (float, 0.0, 1.0, 0.05) var strength := 1.0

#func _physics_process(_delta):
#	self.global_position = get_parent().global_position
