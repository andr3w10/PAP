extends KinematicBody2D
class_name Boss

signal dialogue_triggered

signal drop_loot

enum Groups {ALLY, ENEMY, NEUTRAL}

onready var damage_animator = $DamageAnimator
onready var animation_player : AnimationPlayer = get_node_or_null("AnimationPlayer")
onready var attack_cooldown = $Timers/AttackCooldown
onready var prepare_timer = $Timers/AttackPreparation
onready var recharge_timer = $Timers/RechargeTimer
onready var start_fight_delay = $Timers/StartFightDelay

export var move_speed : float = 5.0
export var max_health = 50
export (Groups) var group = 1
export var attack_range = 5.0 * 16.0 #tile (16)
export var detect_distance = 24.0 * 16.0 #tile (16)

export (Vector2) var player_start_fight_position = Vector2(0, 0)

export (String) var boss_name = ""

export (String) var dialogue_id = ""

onready var health = max_health setget set_health

var velocity := Vector2()
var can_move = false #because the player needs to start the fight

var is_prepared = false

var is_dead = false

var boss_pedestal = null


var current_attack : String = "attack_tier_1"


func _ready():
	Globals.current_boss = self

func _apply_movement():
	if can_move && !is_dead:
		velocity = move_and_slide(velocity)
	else:
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())
		velocity = move_and_slide(velocity)

func _apply_stop_velocity():
	if is_dead == false:
		if velocity.x < 0 && animation_player.has_animation("idle_left"):
			animation_player.play("idle_left")
		elif velocity.x >= 0 && animation_player.has_animation("idle_right"):
			animation_player.play("idle_right")
		
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

#stop no animation
func _apply_stopna_velocity():
	if is_dead == false:
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_move_velocity():
	var target = get_target()
	if target != null:
		move_towards(target.global_position)

	if velocity.x < 0 && animation_player.has_animation("run_left"):
		animation_player.play("run_left")
	elif velocity.x >= 0 && animation_player.has_animation("run_right"):
		animation_player.play("run_right")

func move_towards(to, anim = true):
	if !is_dead:
		if anim:
			if !animation_player.is_playing():
				if velocity.x < 0 && animation_player.has_animation("run_left"):
					animation_player.play("run_left")
				elif velocity.x >= 0 && animation_player.has_animation("run_right"):
					animation_player.play("run_right")
		var displacement = to - global_position
		var seek = displacement.normalized()
		var avoidance = get_avoidance()
		var direction = seek + avoidance
		velocity = lerp(velocity, direction * move_speed * 24, get_move_weight())
	else:
		_apply_stopna_velocity()

func get_avoidance():
	var neighbor_detector = $NeighborDetector
	var avoidance = Vector2()
	var bodies = neighbor_detector.get_overlapping_bodies()
	var count = 0
	for body in bodies:
		if body != self && body.is_in_group("Enemies"):
			avoidance += (global_position - body.global_position).normalized()
			count += 1
	if count < 0:
		avoidance = (avoidance / count).normalized()
	return avoidance

func is_within_attack_range() -> bool:
	var target = get_target()
	if target == null:
		return false
	
	var distance = (target.global_position - global_position).length()
	return distance < attack_range

func _on_Hitbox_damaged(amount, _knockback_strength, _damage_scource, _attacker):
#	damaged_audio_stream_player.pitch_scale = rand_range(0.8, 1.2)
#	damaged_audio_stream_player.play()
	
	set_health(health - amount)
#	damage_animator.play("damage")
#	if hitbox.immunity_duration != 0:
#		damage_animator.queue("invulnerability")

func attack():
	is_prepared = false
	var attack = funcref(self, current_attack)
	attack.call_func()

#virtual method, because dont exist a default attack
func attack_tier_1():
	push_error("virtual method attack_tier_1 has not been implemented")
	return

#virtual method, because dont exist a default attack
func attack_tier_2():
	push_error("virtual method attack_tier_2 has not been implemented")
	return

#virtual method, because dont exist a default attack
func attack_tier_3():
	push_error("virtual method attack_tier_3 has not been implemented")
	return

#virtual method, because dont exist a default attack
func is_attacking() -> bool:
	push_error("virtual method is_attacking has not been implemented")
	return false

#virtual method, because dont exist a default attack
func start_boss_fight(pedestal):
	var _value
	_value = connect("dialogue_triggered", Globals.map.ui.dialogue_manager, "init_dialogue", [])
	boss_pedestal = pedestal
	push_error("virtual method is_attacking has not been implemented")

func prepare_attack():
	if velocity.x < 0 && animation_player.has_animation("prepare_left"):
		animation_player.play("prepare_left")
	elif velocity.x >= 0 && animation_player.has_animation("prepare_right"):
		animation_player.play("prepare_right")
	is_prepared = true
	prepare_timer.start()

func recharge():
	if velocity.x < 0 && animation_player.has_animation("recharge_left"):
		animation_player.play("recharge_left")
	elif velocity.x >= 0 && animation_player.has_animation("recharge_right"):
		animation_player.play("recharge_right")
	recharge_timer.start()

func get_move_weight():
	return 0.3

func set_health(value):
	health = clamp(value, 0, max_health)
	Globals.ui.boss_health_bar.set_health(health)
	if health <= (max_health): #100% to 50%
		current_attack = "attack_tier_1"
	if health <= (max_health * 0.6): #60% to 30%
		current_attack = "attack_tier_2"
	if health <= (max_health * 0.3): #30% to 0%
		current_attack = "attack_tier_3"
	if health <= 0:
		die()

func set_max_health(value):
	max_health = value

func die():
	is_dead = true
	self.group = Groups.NEUTRAL
	Globals.current_boss = null
	animation_player.stop()
	emit_signal("drop_loot")
	if animation_player != null && (animation_player.has_animation("die") || (animation_player.has_animation("die_right") && animation_player.has_animation("die_left"))):
		if (animation_player.has_animation("die")):
			animation_player.play("die")
		else:
			if velocity.x < 0 && animation_player.has_animation("die_left"):
				animation_player.play("die_left")
			elif velocity.x >= 0 && animation_player.has_animation("die_right"):
				animation_player.play("die_right")
	if !animation_player.is_playing():
		queue_free()

#virtual method, because dont exist a default attack
func die_anim_completed():
	push_error("virtual method is_attacking has not been implemented")
	return


func get_target():
	if can_move:
		var nearest_target = null
		if (is_dead == false):
			if Globals.map.map_name != "LevelEditor":
				var distance = detect_distance
				var characters = Globals.map.characters
				for character in characters.get_children():
					if character.group == Groups.ALLY && character.is_detectable:
						var this_distance = (character.global_position - global_position).length()
						if this_distance < distance:
							nearest_target = character
							distance = this_distance
		return nearest_target


func _on_StartFightDelay_timeout():
	can_move = true
