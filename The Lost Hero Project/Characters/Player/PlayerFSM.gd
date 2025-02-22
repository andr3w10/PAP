extends StateMachine

const STOP_THRESHOLD = 8.0

func _ready():
	add_state("idle")
	add_state("run")
	add_state("dodge")
	call_deferred("set_state", states.idle)

func _input(event):
	if event.is_action_pressed("dodge"):
		if [states.idle, states.run].has(state):
			set_state(states.dodge)

func _state_logic(_delta):
	match state:
		states.idle, states.run:
			parent._update_move_input()
			parent._update_velocity()
			parent._update_look()
		states.dodge:
			pass
	
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.velocity.length() >= STOP_THRESHOLD:
				return states.run
		states.run:
			if parent.velocity.length() < STOP_THRESHOLD:
				return states.idle
		states.dodge:
			if parent.dodge_timer.is_stopped():
				return states.idle

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.idle()
		states.run:
			parent.run()
		states.dodge:
			parent.dodge()

func _exit_state(old_state, _new_state):
	match old_state:
		states.dodge:
			parent.exit_dodge()
