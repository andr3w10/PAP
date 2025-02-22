extends BossStateMachine

var temp = 1
var temp1 = 1

func _ready():
	add_state("idle")
	add_state("move")
	add_state("attack_1")
	add_state("attack_2")
	add_state("attack_3")
	add_state("attack_3_1")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	match state:
		states.idle:
			parent.get_target()
			parent._apply_stop_velocity()
			parent._apply_movement()
		states.move:
			parent._apply_move_velocity()
			parent._apply_movement()
		#attack_1
		states.attack_1:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		#attack_2
		states.attack_2:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		#attack_3
		states.attack_3:
			parent._apply_stopna_velocity()
			parent._apply_movement()
		states.attack_3_1:
			parent._apply_move_velocity()
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
						return states.attack_1
			states.attack_1:
				if !parent.is_attacking():
					return states.move

	elif parent.current_attack == "attack_tier_2":
		temp1 = 0
		if temp == 0:
			temp = 1
			return states.idle
		match state:
			states.idle:
				if parent.get_target() != null:
#					return states.move
					return states.attack_2
#			states.move:
#				if parent.get_target() == null:
#					return states.idle
#				else:
#					if parent.is_within_attack_range():
#						return states.attack_2
			states.attack_2:
				if !parent.is_attacking():
					return states.idle

	elif parent.current_attack == "attack_tier_3":
		if temp1 == 0:
			temp1 = 1
			return states.idle
		match state:
			states.idle:
				if parent.get_target() != null:
					return states.move
			states.move:
				if parent.get_target() == null:
					return states.idle
				else:
					if parent.is_within_attack_range():
						return states.attack_3
					else:
						return states.attack_3_1
			states.attack_3_1:
				if parent.is_within_attack_range():
					return states.attack_3
				if !parent.is_attacking(1):
					return states.move
			states.attack_3:
				if !parent.is_attacking(0):
					return states.move
	

func _enter_state(new_state, _old_state):
	match new_state:
		states.attack_1:
			parent.attack_tier_1()
		
		states.attack_2:
			parent.attack_tier_2()
		
		states.attack_3:
			parent.attack_tier_3()
		
		states.attack_3_1:
			parent.attack_tier_3_1()

func _exit_state(_old_state, _new_state):
	pass
