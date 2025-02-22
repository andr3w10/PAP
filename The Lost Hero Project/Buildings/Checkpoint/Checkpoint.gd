extends Node2D

const LAST_FRAME = 49

onready var animated_sprites = $CheckpointAnimation

#lights
onready var mid_star = $Lights/MidStar
onready var left_star = $Lights/LeftStar
onready var right_star = $Lights/RightStar
onready var down_star = $Lights/DownStar
onready var top_star = $Lights/TopStar
onready var left_column = $Lights/LeftColumn
onready var right_column = $Lights/RightColumn

var is_recently_saved = false

func _ready():
	for i in get_node("Lights").get_children():
		i.strength = 0.0

func _on_PlayerDetector_body_entered(_body):
	animated_sprites.play("default")

func _on_PlayerDetector_body_exited(_body):
	animated_sprites.play("default", true)
	is_recently_saved = false

func _on_CheckpointAnimation_frame_changed():
	if animated_sprites.frame == LAST_FRAME && !is_recently_saved:
		is_recently_saved= true
		save_game()
	
	#lights
	if animated_sprites.frame == 2:
		right_column.visible = !right_column.visible
		left_column.visible = !left_column.visible
		change_light(right_column)
		change_light(left_column)
	if animated_sprites.frame == 40:
		left_star.visible = !left_star.visible
		change_light(left_star)
	if animated_sprites.frame == 41:
		down_star.visible = !down_star.visible
		change_light(down_star)
	if animated_sprites.frame == 42:
		right_star.visible = !right_star.visible
		change_light(right_star)
	if animated_sprites.frame == 43:
		top_star.visible = !top_star.visible
		change_light(top_star)
	if animated_sprites.frame == 48:
		mid_star.visible = !mid_star.visible
		change_light(mid_star)

func change_light(light):
	if light.visible == true:
		light.strength = 0.5
	else:
		light.strength = 0.0

func save_game():
	SaveLoad.save_game()
	Globals.map.ui.right_display_box.game_saved()



