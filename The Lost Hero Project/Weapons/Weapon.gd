extends Node2D

const TORNADO_SCALE = Vector2.ONE * 2.0

onready var tween = $Tween
onready var collision = $Pivot/DamageArea/CollisionShape2D
onready var attack_animator = $AttackAnimator
onready var pivot = $Pivot
onready var damage_area = $Pivot/DamageArea
onready var basic_cooldown_timer = $BasicCooldown
onready var special_cooldown_timer = $SpecialCooldown
onready var attack_audio_stream_player = $AttackAudioStreamPlayer

var cooldown_timer = null #setted on each weapon

export var item_name = ""

export var tool_type = "weapon"

export var radius = 8.0
var basic_cooldown = 0.3
var special_cooldown = 2
var basic_duration = 0.2
var special_duration = 0.2
var item_type = ""

var cooldown = 0
var attack_duration = 0.2

var swipe = -1.0

var can_attack = true

func _ready():
	rotation = -PI / 2.0 * -sign(swipe)
	pivot.rotation = PI / 3.5 * sign(swipe)
	collision.disabled = true
	
	var damage_amount = int(JsonData.item_data[item_name]["ItemDamage"])
	damage_area.damage_amount = damage_amount
	var duration_amount = float(JsonData.item_data[item_name]["ItemDuration"])
	basic_duration = duration_amount
	duration_amount = float(JsonData.item_data[item_name]["SpecialDuration"])
	special_duration = duration_amount
	var cooldown_amount = float(JsonData.item_data[item_name]["ItemCooldown"])
	basic_cooldown = cooldown_amount
	cooldown_amount = float(JsonData.item_data[item_name]["SpecialCooldown"])
	special_cooldown = cooldown_amount
	var type = str(JsonData.item_data[item_name]["ItemType"])
	item_type = type
	
	MouseGrid.visible = false

func primary_attack():
	pass

func secondary_attack():
	pass

func swipe_weapon():
	tween.interpolate_callback(collision, attack_duration, "set", "disabled", true)
	tween.interpolate_property(self, "rotation", PI / 2.0 * sign(swipe), PI / 2.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property(pivot, "rotation", PI / 3.5 * sign(swipe), PI / 3.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	collision.disabled = false
#		if swipe > 0:
#			attack_animator.play("swipe_left")
#		else:
#			attack_animator.play("swipe_right")
	swipe = -swipe
	
	start_cooldown()

func swipe_tool(activate_collision = true):
	if activate_collision:
		tween.interpolate_callback(collision, attack_duration, "set", "disabled", true)
	tween.interpolate_property(self, "rotation", PI / 2.0 * sign(swipe), PI / 2.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property(pivot, "rotation", PI / 3.5 * sign(swipe), PI / 3.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	if activate_collision:
		collision.disabled = false
#		if swipe > 0:
#			attack_animator.play("swipe_left")
#		else:
#			attack_animator.play("swipe_right")
	swipe = -swipe
	
	yield(tween, "tween_completed")
	tween.interpolate_property(self, "rotation", PI / 2.0 * sign(swipe), PI / 2.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property(pivot, "rotation", PI / 3.5 * sign(swipe), PI / 3.0 * -sign(swipe), attack_duration, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
#		if swipe > 0:
#			attack_animator.play("swipe_left")
#		else:
#			attack_animator.play("swipe_right")
	swipe = -swipe
	
	start_cooldown()

func tornado():
	pivot.rotation = 1
	collision.disabled = false
	#cock back
	var current = PI / 2.0 * swipe
	var next = (PI + (PI / 4.0)) * swipe
	var delay = 0.15
	tween.interpolate_property(self, "rotation", current, next, 0.075, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	current = next
	next = current + (6 * PI) * swipe
	tween.interpolate_property(pivot, "scale", Vector2.ONE, TORNADO_SCALE, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
	tween.interpolate_property(self, "rotation", next, current, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	current = next
	next = PI / 2.0 * -swipe
	delay += 0.4 + 0.1
	current = wrapf(current, -PI, PI)
	tween.interpolate_property(self, "rotation", current, next, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	tween.interpolate_property(pivot, "scale", TORNADO_SCALE, Vector2.ONE, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
	tween.interpolate_callback(collision, delay + 0.2, "set", "disabled", true)
	tween.start()
	swipe = -swipe
	
	start_cooldown()

#FIXME: cooldown doesn't match the ability
func flurry():
	rotation = 0
	pivot.rotation = 0
	collision.disabled = false
	var to = position.x + 24
	var duration = 0.1
	var delay = 0.075
	var rot = 0
	var num = 5
	for i in num:
		tween.interpolate_property(self, "position:x", position.x, to, duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		var rand = rand_range(-PI / 16.0, PI / 16.0)
		tween.interpolate_property(self, "rotation", rot, rand, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay - 0.05)
		rot = rand
#		tween.interpolate_callback(self, delay, "set", "rotation", rand)
		delay += duration
		tween.interpolate_property(self, "position:x", to, position.x, duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT, delay)
		delay += duration
	tween.interpolate_callback(self, delay, "set", "rotation", PI / 2.0 * sign(swipe))
	tween.interpolate_callback(pivot, delay, "set", "rotation", PI / 3.0 * sign(swipe))
	tween.interpolate_callback(collision, delay, "set", "disabled", true)
	tween.start()
	
	start_cooldown()

func shockwave():
	var actor = get_parent().get_parent().get_parent()
	swipe_weapon()
	var _ability_duration = 0.2
	for i in range(-1, 2):
		var shockwave = load("res://Weapons/Entities/Shockwave.tscn").instance()
		Globals.map.add_child(shockwave)
		var rotation_offset = -PI / 16.0 * i
		shockwave.global_position = actor.global_position + actor.look.rotated(rotation_offset) * 32.0
		shockwave.rotation = actor.look.rotated(rotation_offset).angle()
	
	start_cooldown()

func arrow():
	var actor = get_parent().get_parent().get_parent()
	var arrow = load("res://Weapons/Entities/Arrow.tscn").instance()
	var normal = (get_global_mouse_position() - global_position).normalized()
	Globals.map.add_entity(arrow)
	arrow.set_direction(normal)
	var rotation_offset = -PI / 16.0 * 0
	arrow.global_position = pivot.global_position + actor.look.rotated(rotation_offset)
	arrow.rotation = actor.look.rotated(rotation_offset).angle()
	#set collisionlayers
	if actor.group: #shooter is enemy : group is idx 1
		arrow.damage_area.set_collision_layer_bit(10, true)
		arrow.damage_area.set_collision_layer_bit(11, false)
	if not actor.group: #shooter is ally : group is idx 0
		arrow.damage_area.set_collision_layer_bit(10, false)
		arrow.damage_area.set_collision_layer_bit(11, true)
	
	if item_name == "Bow":
		attack_animator.play("bow")
	
	start_cooldown()

func triple_arrow():
	var actor = get_parent().get_parent().get_parent()
	for i in range(-1, 2):
		var arrow = load("res://Weapons/Entities/Arrow.tscn").instance()
		var normal = (get_global_mouse_position() - global_position).normalized()
		Globals.map.add_entity(arrow)
		var rotation_offset = -PI / 16.0 * i
		var temp_pivot = pivot.global_position - (normal * 32)
		arrow.global_position = temp_pivot + actor.look.rotated(rotation_offset) * 32.0
		arrow.rotation = actor.look.rotated(rotation_offset).angle()
		arrow.set_direction(normal)
		#set collisionlayers
		if actor.group: #shooter is enemy : group is idx 1
			arrow.damage_area.set_collision_layer_bit(10, true)
			arrow.damage_area.set_collision_layer_bit(11, false)
		if not actor.group: #shooter is ally : group is idx 0
			arrow.damage_area.set_collision_layer_bit(10, false)
			arrow.damage_area.set_collision_layer_bit(11, true)
	
	if item_name == "Bow":
		attack_animator.play("bow")
	
	start_cooldown()

func fire_arrow():
	var actor = get_parent().get_parent().get_parent()
	var arrow = load("res://Weapons/Entities/FireArrow.tscn").instance()
	var normal = (get_global_mouse_position() - global_position).normalized()
	Globals.map.add_entity(arrow)
	arrow.set_direction(normal)
	var rotation_offset = -PI / 16.0 * 0
	arrow.global_position = pivot.global_position + actor.look.rotated(rotation_offset)
	arrow.rotation = actor.look.rotated(rotation_offset).angle()
	#set collisionlayers
	if actor.group: #shooter is enemy : group is idx 1
		arrow.damage_area.set_collision_layer_bit(10, true)
		arrow.damage_area.set_collision_layer_bit(11, false)
	if not actor.group: #shooter is ally : group is idx 0
		arrow.damage_area.set_collision_layer_bit(10, false)
		arrow.damage_area.set_collision_layer_bit(11, true)
	
	if item_name == "Bow":
		attack_animator.play("bow")
	
	start_cooldown()

func update_position(look : Vector2):
	rotation = look.angle()


func start_cooldown():
	#start cooldown
	cooldown_timer.start(cooldown + attack_duration)



func play_sound():
	attack_audio_stream_player.play()
