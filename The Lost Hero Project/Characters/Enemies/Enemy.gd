extends "res://AI/AIRaycasts.gd"

signal drop_loot

func die():
	is_dead = true
	self.group = Groups.NEUTRAL
	animation_player.stop()
	emit_signal("drop_loot")
	if animation_player != null && (animation_player.has_animation("die") || (animation_player.has_animation("dieRight") && animation_player.has_animation("dieLeft"))):
		if (animation_player.has_animation("die")):
			animation_player.stop()
			animation_player.play("die")
		else:
			if velocity.x > 0 && animation_player.has_animation("dieLeft"):
				animation_player.stop()
				animation_player.play("dieLeft")
			elif velocity.x <= 0 && animation_player.has_animation("dieRight"):
				animation_player.stop()
				animation_player.play("dieRight")
	if !animation_player.is_playing():
		queue_free()

func delete_body():
	queue_free()
