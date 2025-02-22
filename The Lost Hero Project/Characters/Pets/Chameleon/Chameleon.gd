extends Pet
#chameleon make the player undetectable

var my_owner_group = null

func give_stats():
	if my_owner_group == null:
		my_owner_group = my_owner.group
	else:
		my_owner.group = my_owner.Groups.NEUTRAL

func remove_stats():
	if my_owner_group != null:
		my_owner.group = my_owner_group
		my_owner_group = null
