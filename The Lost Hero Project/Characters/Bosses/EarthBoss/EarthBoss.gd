extends Boss

var center_map_position = Vector2(0, 20)

var is_attacking_var = false

onready var random_point : Vector2

onready var left_arm = $Body/LeftArm
onready var left_arm_shadow = $Body/ShadowLeftArm
onready var right_arm = $Body/RightArm
onready var right_arm_shadow = $Body/ShadowRightArm
onready var arms_anim_player = get_node("ArmsAnimationPlayer")

export (float) var arms_move_speed = 7.0

var arm := 0
var arms_velocity := Vector2()
var shadow_velocity := Vector2()
var returning_arm := false

func _ready():
	Globals.current_boss = self

func _apply_stop_velocity():
	if is_dead == false:
		if animation_player.has_animation("idle"):
			animation_player.play("idle")
		
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_move_velocity():
	if can_move:
		var target = get_target()
		if target != null:
			move_towards(target.global_position)
			
		if animation_player.has_animation("idle"):
			animation_player.play("idle")

func move_towards(to, anim = true):
	if !is_dead && can_move:
		if anim:
			if !animation_player.is_playing():
				if animation_player.has_animation("idle"):
					animation_player.play("idle")
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
#		if velocity.x < 0 && animation_player.has_animation("idle"):
#			animation_player.play("idle")
#		elif velocity.x >= 0 && animation_player.has_animation("idle"):
#			animation_player.play("idle")
		
		animation_player.play("shockwave")
		is_attacking_var = true

func attack_tier_2():
	var target = get_target()
	if target != null:
		if velocity.x < 0 && animation_player.has_animation("idle"):
			animation_player.play("idle")
		elif velocity.x >= 0 && animation_player.has_animation("idle"):
			animation_player.play("idle")

func attack_tier_3():
	var target = get_target()
	if target != null:
#		if velocity.x < 0 && animation_player.has_animation("idle"):
#			animation_player.play("idle")
#		elif velocity.x >= 0 && animation_player.has_animation("idle"):
#			animation_player.play("idle")
		
		animation_player.play("shockwave")
		is_attacking_var = true


func get_room_rand_point():
	var point1 = Vector2(-200, -150)
	var point2 = Vector2(-200, 130)
	var point3 = Vector2(250, -150)
	var point4 = Vector2(250, 130)
	var point5 = center_map_position
	var points = [point1, point2, point3, point4, point5]
	var choice = 0
	while is_in_position(points[choice]):
		choice = (randi() % 5)
	random_point = points[choice]

func is_attacking():
	return is_attacking_var

func is_in_position(pos):
	var this_distance = (pos - global_position).length()
	if this_distance < 2:
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


func shockwave(size : int, center_pos_op : int):
	var center_pos = null
	if center_pos_op == 0: #from body
		center_pos = global_position
	if center_pos_op == 1: #from left arm
		center_pos = left_arm.global_position + Vector2(-36, 60)
	if center_pos_op == 2: #from right arm
		center_pos = right_arm.global_position + Vector2(36, 60)
	
	var shockwave = load("res://Attack/Shockwave.tscn").instance()
	Globals.map.add_entity(shockwave)
	shockwave.global_position = center_pos
	shockwave.attack("ally", self, size)


func _shockwave_completed(op := 0):
	if op == 0: #body
	#	attack_cooldown.start(3.0)
	#	yield(attack_cooldown, "timeout")
		is_attacking_var = false
	elif op == 1: #arms
		return_arm()


func attack_move_arms(to):
	var moving_arm = null
	var moving_shadow = null
	var offset = Vector2.ZERO

	if arm == 0: #left
		moving_arm = left_arm
		moving_shadow = left_arm_shadow
		offset = Vector2(-36, 60)
	elif arm == 1: #right
		moving_arm = right_arm
		moving_shadow = right_arm_shadow
		offset = Vector2(36, 60)
	
	if !arms_anim_player.is_playing() && !returning_arm: #is not attacking or returning arm		
		var this_distance = (to - (moving_arm.global_position + offset)).length()
		if this_distance < 2:
			arms_velocity = lerp(arms_velocity, Vector2.ZERO, get_move_weight())
			shadow_velocity = arms_velocity
			arms_velocity = moving_arm.move_and_slide(arms_velocity)
			shadow_velocity = moving_shadow.move_and_slide(shadow_velocity)
			
			if arm == 0:
				arms_anim_player.play("shockwave_left")
			elif arm == 1:
				arms_anim_player.play("shockwave_right")
		else:
			if moving_arm != null && moving_shadow != null:
				if !is_dead && can_move:
					if !animation_player.is_playing():
						if animation_player.has_animation("idle"):
							animation_player.play("idle")
					var displacement = to - (moving_arm.global_position + offset)
					var seek = displacement.normalized()
					var avoidance = get_avoidance()
					var direction = seek + avoidance
					arms_velocity = lerp(arms_velocity, direction * arms_move_speed * 24, get_move_weight())
					shadow_velocity = arms_velocity
					arms_velocity = moving_arm.move_and_slide(arms_velocity)
					shadow_velocity = moving_shadow.move_and_slide(shadow_velocity)
				else:
					arms_velocity = lerp(arms_velocity, Vector2.ZERO, get_move_weight())
					shadow_velocity = arms_velocity
					arms_velocity = moving_arm.move_and_slide(arms_velocity)
					shadow_velocity = moving_shadow.move_and_slide(shadow_velocity)
	
	elif !arms_anim_player.is_playing() && returning_arm:
		var this_distance = (Vector2(0, 0) - (moving_arm.position)).length()
		if this_distance < 2:
			arms_velocity = lerp(arms_velocity, Vector2.ZERO, get_move_weight())
			shadow_velocity = arms_velocity
			arms_velocity = moving_arm.move_and_slide(arms_velocity)
			shadow_velocity = moving_shadow.move_and_slide(shadow_velocity)
			moving_arm.position = Vector2(0, 0)
			moving_shadow.position = Vector2(0, 0)
			if arm == 0:
				arm = 1
			elif arm == 1:
				arm = 0
			returning_arm = false
		else:
			var displacement = Vector2(0, 0) - moving_arm.position
			var seek = displacement.normalized()
			var avoidance = get_avoidance()
			var direction = seek + avoidance
			arms_velocity = lerp(arms_velocity, direction * arms_move_speed * 24, get_move_weight())
			shadow_velocity = arms_velocity
			arms_velocity = moving_arm.move_and_slide(arms_velocity)
			shadow_velocity = moving_shadow.move_and_slide(shadow_velocity)

func return_arm():
	returning_arm = true
#	if arm == 0: #left
#		pass
#	elif arm == 1: #right
#		pass
