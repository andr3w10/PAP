extends "res://Characters/Bosses/Boss.gd"

var center_map_position = Vector2(155, 5)

var is_attacking_var = false

onready var random_point : Vector2

func _ready():
	Globals.current_boss = self
	get_room_rand_point()

#func _process(delta):
#	$Label.text = str(is_attacking()) + " | " + str(current_attack)

func _apply_stop_velocity():
	if is_dead == false:
		if is_prepared:
			if velocity.x < 0 && animation_player.has_animation("idle_prep_left"):
				animation_player.play("idle_prep_left")
			elif velocity.x >= 0 && animation_player.has_animation("idle_prep_right"):
				animation_player.play("idle_prep_right")
		else:
			if velocity.x < 0 && animation_player.has_animation("idle_left"):
				animation_player.play("idle_left")
			elif velocity.x >= 0 && animation_player.has_animation("idle_right"):
				animation_player.play("idle_right")
		
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_move_velocity():
	var target = get_target()
	if target != null:
		move_towards(target.global_position)
	
	if is_prepared:
		if velocity.x < 0 && animation_player.has_animation("idle_prep_left"):
			animation_player.play("idle_prep_left")
		elif velocity.x >= 0 && animation_player.has_animation("idle_prep_right"):
			animation_player.play("idle_prep_right")
	else:
		if velocity.x < 0 && animation_player.has_animation("idle_left"):
			animation_player.play("idle_left")
		elif velocity.x >= 0 && animation_player.has_animation("idle_right"):
			animation_player.play("idle_right")

func move_towards(to, anim = true):
	if !is_dead:
		if anim:
			if !animation_player.is_playing():
				if velocity.x < 0 && animation_player.has_animation("idle_left"):
					animation_player.play("idle_left")
				elif velocity.x >= 0 && animation_player.has_animation("idle_right"):
					animation_player.play("idle_right")
		var displacement = to - global_position
		var seek = displacement.normalized()
		var avoidance = get_avoidance()
		var direction = seek + avoidance
		velocity = lerp(velocity, direction * move_speed * 24, get_move_weight())
	else:
		_apply_stopna_velocity()


func attack_tier_1():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("attack_left"):
			animation_player.play("attack_left")
		elif velocity.x >= 0 && animation_player.has_animation("attack_right"):
			animation_player.play("attack_right")
		
		is_prepared = false

func attack_tier_2():
	animation_player.play("attack_2")
	var rand = (randi() % 4) + 1
	var floors = get_parent().get_parent().get_parent().get_node("FireFloors")
	for i in floors.get_children():
		if i.num == rand:
			i.start(3, self)

func attack_tier_3():
	animation_player.play("attack_2")
	var rand1 = 0
	var rand2 = 0
	while rand1 == rand2:
		rand1 = (randi() % 4) + 1
		rand2 = (randi() % 4) + 1
	var floors = get_parent().get_parent().get_parent().get_node("FireFloors")
	for i in floors.get_children():
		if i.num == rand1 || i.num == rand2:
			i.start(3, self)


func pre_attack_2():
	#animations
	animation_player.play("prepare_2")

func pre_attack_3():
	get_room_rand_point()
	#animations
	animation_player.play("prepare_2")

func get_room_rand_point():
	var point1 = Vector2(-20, -104)
	var point2 = Vector2(-20, 130)
	var point3 = Vector2(350, 130)
	var point4 = Vector2(350, -104)
	var points = [point1, point2, point3, point4]
	var choice = 0
	while is_in_position(points[choice]):
		choice = (randi() % 4)
	random_point = points[choice]

func is_attacking():
	if current_attack == "attack_tier_1":
		return animation_player.is_playing()
	elif current_attack == "attack_tier_2" || current_attack == "attack_tier_3":
		if is_attacking_var:
			return true
		else:
			return false

func is_in_position(pos):
	var this_distance = (pos - global_position).length()
	if this_distance < 1:
		return true
	else:
		return false

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

func die():
	is_dead = true
	can_move = false
	self.group = Groups.NEUTRAL
	Globals.current_boss = null
	Globals.ui.animation_player.play("hide_boss_healthbar")
	animation_player.stop()
	#make sure to not attack more
	var floors = get_parent().get_parent().get_parent().get_node("FireFloors")
	for i in floors.get_children():
		i.can_attack = false
		i.visible = false
	
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
