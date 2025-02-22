extends "res://Weapons/Weapon.gd"

func primary_attack():
	if basic_cooldown_timer.is_stopped():
		cooldown_timer = basic_cooldown_timer
		cooldown = basic_cooldown
		attack_duration = basic_duration
		flurry()

func secondary_attack():
	if special_cooldown_timer.is_stopped():
		cooldown_timer = special_cooldown_timer
		cooldown = special_cooldown
		attack_duration = special_duration
		shockwave()
