extends Node2D

onready var sprites = $AnimatedSprite
onready var tween = $Tween
onready var light = $LightSource

export (int) var max_frames = 5

func _ready():
	sprites.animation = str(int(rand_range(1, max_frames)))
	sprites.play()
	change_lights()

func _process(_delta):
	if not tween.is_active():
		change_lights()

func change_lights():
	tween.interpolate_property(light, "radius", rand_range(75, 80), rand_range(70, 75), rand_range(0.6, 1.2), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(light, "radius", rand_range(70, 75), rand_range(75, 80), rand_range(0.6, 1.2), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	tween.start()

func _on_AnimatedSprite_animation_finished():
	sprites.animation = str(int(rand_range(1, max_frames)))
	sprites.play()
