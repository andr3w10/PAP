extends Boss

var is_attacking_var = true

func _ready():
	Globals.current_boss = self


func start_boss_fight(pedestal):
	var _value
	_value = connect("dialogue_triggered", Globals.map.ui.dialogue_manager, "init_dialogue", [])
	boss_pedestal = pedestal
	Globals.ui.animation_player.play("flash")
	yield(get_tree().create_timer(0.2), "timeout")
	self.visible = true
	Globals.player.position = player_start_fight_position
	Globals.ui.boss_health_bar.change_boss_name(boss_name)
	Globals.ui.boss_health_bar.set_max_health(max_health)
	Globals.ui.boss_health_bar.set_health(max_health)
	Globals.ui.boss_health_bar.visible = true
	pedestal.get_node("orb").visible = false
	can_move = false
	Globals.player.can_move = false
	yield(get_tree().create_timer(1.8), "timeout")
	get_tree().paused = true
	Globals.can_open_menu = false
	emit_signal("dialogue_triggered", dialogue_id)
	yield(Globals.map.ui.dialogue_manager, "finished")
	get_tree().paused = false
	Globals.can_open_menu = true
	disconnect("dialogue_triggered", Globals.map.ui.dialogue_manager, "init_dialogue")
	can_move = true
	Globals.player.can_move = true


func is_attacking(op = 0):
	if current_attack == "attack_tier_1":
		return animation_player.is_playing()
	elif current_attack == "attack_tier_2":
		if is_attacking_var:
			return true
		else:
			return false
	elif current_attack == "attack_tier_3":
		if op == 0:
			return animation_player.is_playing()
		elif op == 1:
			if is_attacking_var:
				return true
			else:
				return false

func _water_splash_completed():
	is_attacking_var = false

func attack_tier_1():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("attack_left"):
			animation_player.play("attack_left")
		elif velocity.x >= 0 && animation_player.has_animation("attack_right"):
			animation_player.play("attack_right")

func attack_tier_2():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("idle_left"):
			animation_player.play("idle_left")
		elif velocity.x >= 0 && animation_player.has_animation("idle_right"):
			animation_player.play("idle_right")
		
		var attack_splash = load("res://Attack/WaterSplash.tscn").instance()
		Globals.map.add_entity(attack_splash)
		attack_splash.global_position = target.global_position
		attack_splash.attack("ally", self, true, 1.0)
		is_attacking_var = true

func attack_tier_3():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("attack_left"):
			animation_player.play("attack_left")
		elif velocity.x >= 0 && animation_player.has_animation("attack_right"):
			animation_player.play("attack_right")

func attack_tier_3_1():
	var target = get_target()
	if target != null:
		var attack_splash = load("res://Attack/WaterSplash.tscn").instance()
		Globals.map.add_entity(attack_splash)
		attack_splash.global_position = target.global_position
		attack_splash.attack("ally", self, true, 0.5)
		is_attacking_var = true

func die():
	is_dead = true
	can_move = false
	self.group = Groups.NEUTRAL
	Globals.current_boss = null
	Globals.ui.animation_player.play("hide_boss_healthbar")
	animation_player.stop()
	
	if animation_player != null && (animation_player.has_animation("die") || (animation_player.has_animation("die_right") && animation_player.has_animation("die_left"))):
		if (animation_player.has_animation("die")):
			animation_player.play("die")
		else:
			if velocity.x < 0 && animation_player.has_animation("die_left"):
				animation_player.play("die_left")
			elif velocity.x >= 0 && animation_player.has_animation("die_right"):
				animation_player.play("die_right")


func die_anim_completed():
	emit_signal("drop_loot")
	boss_pedestal.boss_defeated()
	queue_free()
