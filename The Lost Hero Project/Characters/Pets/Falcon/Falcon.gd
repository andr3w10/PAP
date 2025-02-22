extends Pet
#FIXME: whe the camera zooms out, the lights bug

#alcon gives extra vision

export (float) var extra_vision = 0.1

var camera_zoom = null

func give_stats():
	if camera_zoom == null:
		camera_zoom = Globals.camera.zoom
	else:
		Globals.camera.zoom.x = camera_zoom.x + extra_vision
		Globals.camera.zoom.y = camera_zoom.y + extra_vision

func remove_stats():
	if camera_zoom != null:
		Globals.camera.zoom = camera_zoom
		camera_zoom = null

# NOT WORKING!!!
func _apply_takeoff_velocity():
	if velocity.x < 0 && animation_player.has_animation("takeoffLeft"):
		animation_player.play("takeoffLeft")
	elif velocity.x >= 0 && animation_player.has_animation("takeoffRight"):
		animation_player.play("takeoffRight")
	
	velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_land_velocity():
	if velocity.x < 0 && animation_player.has_animation("takeoffLeft"):
		animation_player.play_backwards("takeoffLeft")
	elif velocity.x >= 0 && animation_player.has_animation("takeoffRight"):
		animation_player.play_backwards("takeoffRight")
	
	velocity = lerp(velocity, Vector2.ZERO, get_move_weight())
