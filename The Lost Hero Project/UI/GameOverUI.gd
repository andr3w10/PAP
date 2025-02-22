extends Control

func _on_revive_pressed():
	if PlayerInventory.coins >= 50:
		var animation_player = get_parent().get_node("AnimationPlayer")
		Globals.player.health = Globals.player.max_health
		Globals.player.is_dead = true
		Globals.player.group = Globals.player.Groups.ALLY
		PlayerInventory.add_coins(-50)
		animation_player.play("hide_game_over")
		yield(animation_player, "animation_finished")
		Globals.can_open_menu = true
		get_tree().paused = false
	else:
		get_node("Label2").visible = true


func _on_quit_pressed():
	get_tree().quit()
