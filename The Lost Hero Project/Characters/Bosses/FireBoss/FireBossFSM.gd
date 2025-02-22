extends BossStateMachine

var temp = 1
var temp1 = 1

func _ready():
	add_state("idle")
	add_state("move")
	add_state("move_center")
	add_state("prepare")
	add_state("attack_1")
	add_state("attack_2")
	add_state("pre_attack_2")
	add_state("move_random")
	add_state("attack_3")
	add_state("pre_attack_3")
	add_state("recharge")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	match state:
		states.idle:
			parent.get_target()
			parent._apply_stop_velocity()
			parent._apply_movement()
		#attack_1
		states.move:
			parent._apply_move_velocity()
			parent._apply_movement()
		states.prepare:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		states.attack_1:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		states.recharge:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		#attack_2
		states.pre_attack_2:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		states.attack_2:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		states.move_center:
			parent.move_towards(parent.center_map_position)
			parent._apply_movement()
		#attack_3
		states.pre_attack_3:
			if parent.is_in_position(parent.random_point):
				parent._apply_stopna_velocity()
				parent._apply_movement()
			else:
				parent.move_towards(parent.random_point, false)
				parent._apply_movement()
		states.attack_3:
			if parent.is_in_position(parent.random_point):
				parent._apply_stopna_velocity()
				parent._apply_movement()
			else:
				parent.move_towards(parent.random_point, false)
				parent._apply_movement()
		states.move_random:
			parent.move_towards(parent.random_point)
			parent._apply_movement()

func _get_transition(_delta):
	if parent.current_attack == "attack_tier_1":
		temp = 0
		match state:
			states.idle:
				if parent.get_target() != null:
					return states.move
			states.move:
				if parent.get_target() == null:
					return states.idle
				else:
					if parent.is_within_attack_range():
						return states.prepare
			states.prepare:
				if parent.prepare_timer.is_stopped():
					if parent.is_within_attack_range():
						return states.attack_1
					else:
						return states.idle
			states.attack_1:
				if !parent.is_attacking():
					return states.recharge
			states.recharge:
				if parent.recharge_timer.is_stopped():
					return states.idle

	elif parent.current_attack == "attack_tier_2":
		temp1 = 0
		if temp == 0:
			temp = 1
			return states.move_center
		match state:
			states.move_center:
				if parent.is_in_position(parent.center_map_position):
					return states.pre_attack_2
			states.pre_attack_2:
				if !parent.animation_player.is_playing():
					return states.attack_2
			states.attack_2:
				if !parent.is_attacking():
					return states.pre_attack_2

	elif parent.current_attack == "attack_tier_3":
		if temp1 == 0:
			temp1 = 1
			return states.move_random
		match state:
			states.move_random:
				return states.pre_attack_3
			states.pre_attack_3:
				if !parent.animation_player.is_playing():
					return states.attack_3
			states.attack_3:
				if !parent.is_attacking():
					return states.pre_attack_3
	
	
	#transitions between attack tiers
	if parent.current_attack == "attack_tier_1":
		match state:
			states.pre_attack_2, states.attack_2, states.move_center, states.pre_attack_3, states.attack_3, states.move_random:
				return states.idle
				
	elif parent.current_attack == "attack_tier_2":
		match state:
			states.pre_attack_3, states.attack_3, states.move_random:
				return states.move_center

func _enter_state(new_state, _old_state):
	match new_state:
		states.prepare:
			if !parent.is_prepared:
				parent.prepare_attack()
		states.attack_1:
			parent.attack_tier_1()
		states.recharge:
			parent.recharge()
		
		states.pre_attack_2:
			parent.pre_attack_2()
		states.attack_2:
			parent.is_attacking_var = true
			parent.attack_tier_2()
		
		states.pre_attack_3:
			parent.pre_attack_3()
		states.attack_3:
			parent.is_attacking_var = true
			parent.attack_tier_3()
		states.move_random:
			parent.get_room_rand_point()

func _exit_state(_old_state, _new_state):
	pass
