extends StateMachine

func _ready():
	add_state("idle")
	add_state("follow")
	add_state("sleep")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	match state:
		states.idle:
			parent.get_player()
			parent._apply_stop_velocity()
			parent._apply_movement()
		states.follow:
			if parent.get_player() != null:
				if !parent.is_near_to_player():
					parent._apply_follow_velocity(parent.get_player())
				else:
					parent._apply_move_stop_velocity()
			else:
				parent._apply_stop_velocity()
			parent._apply_movement()
		states.sleep:
			parent._apply_sleep_velocity()
			parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.my_owner != null:
				if parent.my_owner.pet == parent:
					return states.follow
			if parent.is_sleeping:
				return states.sleep
		states.follow:
			if parent.get_player() == null:
				return states.idle
			if parent.is_sleeping:
				return states.sleep
		states.sleep:
			if parent.is_sleeping == false:
				return states.idle

func _enter_state(new_state, _old_state):
	match new_state:
		states.sleep:
			if parent.velocity.x < 0 && parent.animation_player.has_animation("goSleepLeft"):
				parent.animation_player.play("goSleepLeft")
			elif parent.velocity.x >= 0 && parent.animation_player.has_animation("goSleepRight"):
				parent.animation_player.play("goSleepRight")

func _exit_state(_old_state, _new_state):
	pass
