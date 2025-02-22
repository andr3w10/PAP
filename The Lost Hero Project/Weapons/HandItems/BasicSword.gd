extends "res://Weapons/Weapon.gd"

func primary_attack():
	if basic_cooldown_timer.is_stopped():
		cooldown_timer = basic_cooldown_timer
		cooldown = basic_cooldown
		attack_duration = basic_duration
		swipe_tool()
		play_sound()
