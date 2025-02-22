extends StateMachine

func _ready():
	add_state("idle")
	add_state("wander")
	add_state("emote")
	add_state("chase")
	add_state("prepare")
	add_state("telegraph")
	add_state("cast_spell")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	match state:
		states.idle:
			parent.get_target()
			parent._apply_stop_velocity()
			parent._apply_movement()
		states.wander:
			parent.get_target()
			parent._apply_wander_velocity()
			parent._apply_movement()
		states.emote:
			parent._apply_stop_velocity()
			parent._apply_movement()
		states.chase:
			if parent.get_target() != null && !parent.is_emoting:
				if !parent.is_within_attack_range():
					parent._apply_chase_velocity()
				else:
					parent._apply_stop_velocity()
			else:
				parent._apply_stop_velocity()
			parent._apply_movement()
		states.prepare, states.telegraph, states.cast_spell:
			parent._apply_stop_velocity()
			parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.get_target() != null:
				return states.emote
			elif parent.idle_timer.is_stopped():
				return states.wander
		states.wander:
			if parent.get_target() != null:
				return states.emote
			elif (parent.move_to_point - parent.global_position).length() < 6: #a quarter tile error
				return states.idle
		states.emote:
			#the check if the emote is active is done on chase state
			return states.chase
		states.chase:
			if parent.get_target() == null:
				return states.idle
			else:
				if parent.is_within_attack_range():
					return states.prepare
		states.prepare:
			if parent.get_target() == null:
				return states.chase
			if parent.prepare_timer.is_stopped():
				return states.telegraph
		states.telegraph:
			if !parent.animation_player.is_playing():
				return states.cast_spell
		states.cast_spell:
			if !parent.is_attacking():
				return states.chase

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.idle_timer.start(rand_range(1.0, 2.0))
		states.emote:
			parent.emote("alert")
		states.prepare:
			parent.prepare_attack()
		states.telegraph:
			parent.telegraph_attack()
		states.cast_spell:
			parent.attack()

func _exit_state(_old_state, _new_state):
	pass
