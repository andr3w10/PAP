extends KinematicBody2D
class_name Character

const KNOCKBACK_VELOCITY = 400

enum Groups {ALLY, ENEMY, NEUTRAL}

onready var alert_timer = $Timers/AlertTimer
onready var idle_timer = $Timers/IdleTimer
onready var wander_timer = $Timers/WanderTimer
onready var dodge_cooldown = $Timers/DodgeCooldown
onready var dodge_timer = $Timers/DodgeTimer
onready var sleep_timer = $Timers/SleepTimer
onready var attack_cooldown = $Timers/AttackCooldown
onready var hitbox = $Hitbox
onready var pivot = $Body/Pivot
onready var prepare_timer = $Timers/AttackPreparation
onready var damage_animator = $DamageAnimator
onready var animation_player : AnimationPlayer = get_node_or_null("AnimationPlayer")
onready var emote_ui = $Emote
onready var damaged_audio_stream_player = $Audio/DamagedAudioStreamPlayer

export var move_speed : float = 6.0
export var wander_speed : float = 2.0
export var max_health = 5
export (Groups) var group = 0
export var knockback_modifier : float = 1.0
export var attack_range = 12.0 #tile (16)
export var detect_distance = 14.0 * 16.0 #tile (16)
export var max_wander_radius = 10.0 * 16.0 #tile (16)

onready var chase_speed : float = move_speed

onready var spawn_position : Vector2 = global_position

onready var health = max_health setget set_health

var velocity := Vector2()
var move_input := Vector2()
var look := Vector2()
var hand_item = null

var is_emoting = false
var can_move = true
var is_detectable = true

var follow_target = null

var move_to_point := Vector2.ZERO

var is_dead = false

func _ready():
	damage_animator.play("reset")
#	yield()
#	Globals.map.add_character(self)

func _apply_wander_velocity():
	move_speed = wander_speed
	
	if wander_timer.is_stopped():
		var point : Vector2
		point = get_random_point_in_circle(max_wander_radius)
		move_to_point = point + spawn_position
		
		wander_timer.start(rand_range(3.0, 5.0))
	
	move_towards(move_to_point)
	
	if velocity.x < 0 && animation_player.has_animation("runLeft"):
		animation_player.play("runLeft")
	elif velocity.x >= 0 && animation_player.has_animation("runRight"):
		animation_player.play("runRight")

func _apply_chase_velocity(target = get_target()):
	move_speed = chase_speed
	
	if target != null:
		move_towards(target.global_position)
	
	if velocity.x < 0 && animation_player.has_animation("runLeft"):
		animation_player.play("runLeft")
	elif velocity.x >= 0 && animation_player.has_animation("runRight"):
		animation_player.play("runRight")

func _apply_follow_velocity(target):
	if target != null:
		move_speed = target.move_speed
		move_towards(target.global_position)
	if velocity.x < 0 && animation_player.has_animation("runLeft"):
		animation_player.play("runLeft")
	elif velocity.x >= 0 && animation_player.has_animation("runRight"):
		animation_player.play("runRight")

func _apply_stop_velocity():
	if is_dead == false:
		if velocity.x < 0 && animation_player.has_animation("idleLeft"):
			animation_player.play("idleLeft")
		elif velocity.x >= 0 && animation_player.has_animation("idleRight"):
			animation_player.play("idleRight")
		
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_stopna_velocity():
	if is_dead == false:
		
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_move_stop_velocity():
	if (velocity.x < 24 && velocity.x > -24) && (velocity.y < 24 && velocity.y > -24):
		if velocity.x < 0 && animation_player.has_animation("idleLeft"):
			animation_player.play("idleLeft")
		elif velocity.x >= 0 && animation_player.has_animation("idleRight"):
			animation_player.play("idleRight")
	
	else:
		if velocity.x < 0 && animation_player.has_animation("runLeft"):
			animation_player.play("runLeft")
		elif velocity.x > 0 && animation_player.has_animation("runRight"):
			animation_player.play("runRight")
	
	velocity = lerp(velocity, Vector2.ZERO, get_move_weight())

func _apply_movement():
	if can_move:
		velocity = move_and_slide(velocity)
	else:
		velocity = lerp(velocity, Vector2.ZERO, get_move_weight())
		velocity = move_and_slide(velocity)

func move_towards(to):
	var displacement = to - global_position
	var seek = displacement.normalized()
	var avoidance = get_avoidance()
	var direction = seek + avoidance
	velocity = lerp(velocity, direction * move_speed * 24, get_move_weight())

func get_move_weight():
	return 0.3

func _on_Hitbox_damaged(amount, knockback_strength, damage_scource, _attacker):
	damaged_audio_stream_player.pitch_scale = rand_range(0.8, 1.2)
	damaged_audio_stream_player.play()
	
	set_health(health - amount)
	if damage_scource != null:
		knockback(knockback_strength, damage_scource.global_position)
	damage_animator.play("damage")
	if hitbox.immunity_duration != 0:
		damage_animator.queue("invulnerability")

func knockback(knockback_strength, source_position):
	var normal = (global_position - source_position).normalized()
	if knockback_modifier != 0:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		die()

func set_max_health(value):
	max_health = value

func die():
	is_dead = true
	self.group = Groups.NEUTRAL
	animation_player.stop()
	if animation_player != null && (animation_player.has_animation("die") || (animation_player.has_animation("dieRight") && animation_player.has_animation("dieLeft"))):
		if (animation_player.has_animation("die")):
			animation_player.play("die")
		else:
			if velocity.x < 0 && animation_player.has_animation("dieLeft"):
				animation_player.play("dieLeft")
			elif velocity.x >= 0 && animation_player.has_animation("dieRight"):
				animation_player.play("dieRight")
	if !animation_player.is_playing():
		queue_free()


func _on_Hitbox_immunity_ended():
	damage_animator.play("reset")

func get_target():
	if follow_target == null:
		var nearest_target = null
		if (is_dead == false):
			if Globals.map.map_name != "LevelEditor":
				var distance = detect_distance
				var characters = Globals.map.characters
				for character in characters.get_children():
					if character.group == Groups.ALLY && character.is_detectable && character != self:
						var this_distance = (character.global_position - global_position).length()
						if this_distance < distance:
							nearest_target = character
							distance = this_distance
		return nearest_target
	else:
		return follow_target

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

func is_within_attack_range(target = get_target()) -> bool:
	if target == null:
		return false
	
	var distance = (target.global_position - global_position).length()
	return distance < attack_range

func prepare_attack():
	prepare_timer.start()

func telegraph_attack():
	if animation_player != null && animation_player.has_animation("telegraph"):
		animation_player.play("telegraph")

#virtual method, because dont exist a default attack
func attack():
	push_error("virtual method attack has not been implemented")
	return

#virtual method, because dont exist a default attack
func is_attacking() -> bool:
	push_error("virtual method is_attacking has not been implemented")
	return false

func emote(emote_type):
	var tween = emote_ui.get_node("Tween")
	emote_ui.visible = true
	tween.interpolate_property(emote_ui, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emote_ui.get_node("EmotePicker").animation = emote_type
	is_emoting = true
	emote_ui.get_node("EmoteTimer").start()
	yield(emote_ui.get_node("EmoteTimer"), "timeout")
	is_emoting = false
	emote_ui.get_node("EmotePicker").animation = "null"
	tween.interpolate_property(emote_ui, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emote_ui.visible = false


func get_random_point_in_circle (radius : float) -> Vector2:
	var x1 = rand_range (-1, 1)
	var x2 = rand_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = rand_range (-1, 1)
		x2 = rand_range (-1, 1)

	var random_pos_on_unit_circle = Vector2 (
	2 * x1 * sqrt (1 - x1*x1 - x2*x2),
	2 * x2 * sqrt (1 - x1*x1 - x2*x2))

	return random_pos_on_unit_circle * rand_range(0, radius)
