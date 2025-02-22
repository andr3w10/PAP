extends Pet
#cat gives extra lifes to the player

export (int) var extra_lifes = 2

var owner_max_health = null

func give_stats():
	if owner_max_health == null:
		owner_max_health = my_owner.max_health
	else:
		if my_owner.max_health != owner_max_health + extra_lifes:
			my_owner.set_max_health(owner_max_health + extra_lifes)
			if my_owner.health == owner_max_health:
				my_owner.set_health(owner_max_health + extra_lifes)
func remove_stats():
	if owner_max_health != null:
		my_owner.set_max_health(owner_max_health)
		owner_max_health = null
