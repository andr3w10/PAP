extends "res://Characters/Pets/PetFSM.gd"

func _ready():
	add_state("idle")
	add_state("takeoff")
	add_state("land")
	add_state("follow")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	match state:
		states.idle:
			parent.get_player()
			parent._apply_stop_velocity()
			parent._apply_movement()
		states.takeoff:
			parent.get_player()
			parent._apply_takeoff_velocity()
			parent._apply_movement()
		states.land:
			parent.get_player()
			parent._apply_land_velocity()
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

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.my_owner != null:
				if parent.my_owner.pet == parent:
					return states.takeoff
		states.takeoff:
			if !parent.animation_player.is_playing():
				return states.follow
		states.land:
			if !parent.animation_player.is_playing():
				return states.idle
		states.follow:
			if parent.get_player() == null:
				return states.land

func _enter_state(_new_state, _old_state):
	pass

func _exit_state(_old_state, _new_state):
	pass
