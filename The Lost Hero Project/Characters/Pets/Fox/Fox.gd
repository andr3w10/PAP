extends Pet
#fox gives extra move speed

export (float) var extra_move_speed = 1.0

var owner_move_speed = null

func give_stats():
	if owner_move_speed == null:
		owner_move_speed = my_owner.move_speed
	else:
		my_owner.move_speed = owner_move_speed + extra_move_speed

func remove_stats():
	if owner_move_speed != null:
		my_owner.move_speed = owner_move_speed
		owner_move_speed = null
