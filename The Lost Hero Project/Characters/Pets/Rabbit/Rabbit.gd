extends Pet
#rabbit change dodge to dash and allow the player to attack using the dash

export (float) var DASH_VELOCITY = 15 * 24

var owner_dodge_op = null

func give_stats():
	if owner_dodge_op == null:
		owner_dodge_op = my_owner.dodge_op
	else:
		my_owner.dodge_op = 1

func remove_stats():
	if owner_dodge_op != null:
		my_owner.dodge_op = owner_dodge_op
		owner_dodge_op = null
