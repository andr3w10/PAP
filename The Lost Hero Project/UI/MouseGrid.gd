extends Node2D

var TILE_SIZE = 16

var can : bool = true
var validate : bool = false

onready var sprite = $Sprite

func _process(_delta):
	position = (get_global_mouse_position() / TILE_SIZE).floor() * TILE_SIZE

#func turn_visible(op: bool):
#	if op == true:
#		self.visible = true
#	else:
#		self.visible = false

func texture(tex):
	match tex:
		"16":
			sprite.texture = load("res://PixelArt/UI/Grids/mouseGrid16.png")
			sprite.position = Vector2(8, 8)
			TILE_SIZE = 16
		"24":
			if validate:
				if can:
					sprite.texture = load("res://PixelArt/UI/Grids/green_mouseGrid24.png")
				else:
					sprite.texture = load("res://PixelArt/UI/Grids/red_mouseGrid24.png")
			else:
				sprite.texture = load("res://PixelArt/UI/Grids/mouseGrid24.png")
			sprite.position = Vector2(12, 12)
			TILE_SIZE = 24
