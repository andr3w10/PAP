extends "res://Weapons/Weapon.gd"

func _ready():
	rotation = 0
	pivot.rotation = 0
	collision.disabled = true
	
	var damage_amount = int(JsonData.item_data[item_name]["ItemDamage"])
	damage_area.damage_amount = damage_amount
	var duration_amount = float(JsonData.item_data[item_name]["ItemDuration"])
	basic_duration = duration_amount
	duration_amount = float(JsonData.item_data[item_name]["SpecialDuration"])
	special_duration = duration_amount
	var cooldown_amount = float(JsonData.item_data[item_name]["ItemCooldown"])
	basic_cooldown = cooldown_amount
	cooldown_amount = float(JsonData.item_data[item_name]["SpecialCooldown"])
	special_cooldown = cooldown_amount
	var type = str(JsonData.item_data[item_name]["ItemType"])
	item_type = type

func primary_attack():
	if basic_cooldown_timer.is_stopped():
		cooldown_timer = basic_cooldown_timer
		cooldown = basic_cooldown
		attack_duration = basic_duration
		arrow()
		play_sound()

func secondary_attack():
	if special_cooldown_timer.is_stopped():
		cooldown_timer = special_cooldown_timer
		cooldown = special_cooldown
		attack_duration = special_duration
		fire_arrow()
		play_sound()
