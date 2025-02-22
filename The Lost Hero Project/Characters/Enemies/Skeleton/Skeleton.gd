extends "res://Characters/Enemies/Enemy.gd"

func attack():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("attackLeft"):
			animation_player.play("attackLeft")
		elif velocity.x >= 0 && animation_player.has_animation("attackRight"):
			animation_player.play("attackRight")
