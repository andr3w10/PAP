extends Area2D

export (int) var num = 0
export (int) var dps = 1

onready var alert_timer = $alert_time
onready var dps_timer = $dps
onready var attack_timer = $attack_time
onready var animation_player = $AnimationPlayer

var can_attack = true

var boss = null

func start(alert_time, attacker):
	boss = attacker
	self.visible = true
	can_attack = true
	alert_timer.start(alert_time)
	animation_player.stop()
	animation_player.play("blink_alert")

func damage_player():
	var areas = get_overlapping_areas()
	for area in areas:
		var body = area.get_parent()
		if body == Globals.player:
			body._on_Hitbox_damaged(dps, null, null, null)

func stop_attacking():
	if !boss.is_dead:
		can_attack = false
		self.visible = false
		boss.is_attacking_var = false

func heal_boss():
	var areas = get_overlapping_areas()
	for area in areas:
		var body = area.get_parent()
		if body == Globals.current_boss:
			body.set_health(Globals.current_boss.health + dps)

func _on_alert_time_timeout():
	if can_attack:
		animation_player.stop()
		animation_player.play("attack")
		attack_timer.start()
		dps_timer.start()
		damage_player()
		heal_boss()

func _on_dps_timeout():
	if can_attack:
		damage_player()
		dps_timer.start()

func _on_attack_time_timeout():
	stop_attacking()
