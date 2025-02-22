extends "res://Weapons/Weapon.gd"

var mode = 0 #0 -> normal weapon and collect item // 1 -> hoe dirt

func _ready():
	#default weapon settings
	rotation = -PI / 2.0 * -sign(swipe)
	pivot.rotation = PI / 3.5 * sign(swipe)
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
		if mode == 0:
			swipe_tool()
			play_sound()
		elif mode == 1:
			swipe_tool(false)
			play_sound()
			Globals.map.farm.hoe_dirt()

func secondary_attack():
	if mode == 0:
		MouseGrid.visible = true
		MouseGrid.validate = true
		MouseGrid.texture("24")
		mode = 1
	elif mode == 1:
		MouseGrid.visible = false
		MouseGrid.validate = false
		mode = 0
