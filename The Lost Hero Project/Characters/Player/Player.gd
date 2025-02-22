extends Character

const DODGE_VELOCITY = 10 * 24
const HAND_RADIUS = 24
const INTERACT_RANGE = 3 * 24

onready var animation_tree = $AnimationTree
onready var hitbox_collision_shape = $Hitbox/CollisionShape2D
onready var pickup_zone = $PickupZone
onready var foot_particles = $Body/FootParticles
onready var footsteps_audio_stream_player = $Audio/FootstepAudioStreamPlayer
onready var footsteps_timer = $Audio/FootstepAudioStreamPlayer/FootstepTimer
onready var coin_audio_stream_player = $Audio/CoinAudioStreamPlayer
onready var item_pick_audio_stream_player = $Audio/ItemPickAudioStreamPlayer

onready var head_sprite = $Body/Head
onready var body_sprite = $Body/Body
onready var shoes_sprite = $Body/Shoes

const skins = preload("res://Inventory/Skins/Skins.gd")

onready var animation_state = animation_tree.get("parameters/playback")

var pet = null
var dodge_op := 0 # 0: default dodge; 1: dash

var to_interact_object = null

var is_moving_towards = false
var target_pos = null

func _ready():
	var _value
	Globals.player = self
	damage_animator.play("reset")
	self.global_position = Globals.player_initial_position
	
	if PlayerStats.max_health == null || PlayerStats.max_health == 0:
		PlayerStats.max_health = max_health
		PlayerStats.health = PlayerStats.max_health
	
	if PlayerStats.move_speed == null:
		set_move_speed(move_speed)
	else:
		move_speed = PlayerStats.move_speed
	
	_value = PlayerInventory.connect("hand_item_removed", self, "update_hand_item")
	
	hand_item = pivot.get_node("BasicSword")
	update_hand_item()
	update_skin()

func _physics_process(_delta):
#	$Label.text = str(z_index)
	
	animation_tree.set("parameters/Idle/blend_position", look)
	animation_tree.set("parameters/Run/blend_position", look)
	animation_tree.set("parameters/Dodge/blend_position", move_input)
	
	#update pivot rotation
	if hand_item.item_type == "Weapon" || hand_item.item_type == "Tool":
		pivot.scale.x = 1
		pivot.scale.y = 1
		pivot.rotation = (get_global_mouse_position() - pivot.global_position).angle()
	else:
		if look.x >= 0:
			pivot.rotation = 0
			pivot.scale.x = 1
			pivot.scale.y = 1
		elif look.x < 0:
			pivot.rotation = 0
			pivot.scale.x = -1
			pivot.scale.y = 1
		
#	if hand_item != null:
#		hand_item.update_position(look)
	
	#pick up zone
	if pickup_zone.items_in_range.size() > 0:
		var pickup_item = pickup_zone.items_in_range.values()[0]
		#sfx
		if pickup_item.type == "coin":
			coin_audio_stream_player.play()
		elif pickup_item.type == "item":
			item_pick_audio_stream_player.play()
		
		pickup_item.pick_up_item(self)
		pickup_zone.items_in_range.erase(pickup_item)
	
	#foot partiles and footsteps
	if move_input == Vector2.ZERO:
		foot_particles.emitting = false
	else:
		foot_particles.emitting = true
		
		if footsteps_timer.is_stopped():
			footsteps_audio_stream_player.pitch_scale = rand_range(0.8, 1.2)
			footsteps_audio_stream_player.play()
			footsteps_timer.start(0.3)
	
	if move_input.x < 0 && move_input.y == 0:
		foot_particles.position.x = 3.5
		foot_particles.process_material.direction.x = 1
		foot_particles.process_material.direction.y = 0
		foot_particles.rotation_degrees = 0
	if move_input.x > 0 && move_input.y == 0:
		foot_particles.position.x = -3.5
		foot_particles.process_material.direction.x = -1
		foot_particles.process_material.direction.y = 0
		foot_particles.rotation_degrees = 0
	if move_input.y < 0 && move_input.x == 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = 1
		foot_particles.rotation_degrees = 0
	if move_input.y > 0 && move_input.x == 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = -1
		foot_particles.rotation_degrees = 0
	
	if move_input.x < 0 && move_input.y < 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = 1
		foot_particles.rotation_degrees = -60
	if move_input.x > 0 && move_input.y < 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = 1
		foot_particles.rotation_degrees = 60
	if move_input.x < 0 && move_input.y > 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = -1
		foot_particles.rotation_degrees = 60
	if move_input.x > 0 && move_input.y > 0:
		foot_particles.position.x = 0
		foot_particles.process_material.direction.x = 0
		foot_particles.process_material.direction.y = -1
		foot_particles.rotation_degrees = -60

func _process(_delta):
	#SHOW COOLDOWNS ON LABLE
#	if hand_item.item_type == "Weapon" || hand_item.item_type == "Tool" || hand_item.item_type == "SpellBook":
#		$Label.text = str(hand_item.basic_cooldown_timer.time_left) + " | " + str(hand_item.special_cooldown_timer.time_left)
	
#	$Label.text = str(z_index)
	
	if pet != null:
		var mouse = get_global_mouse_position() - global_position
		var at = mouse.clamped(INTERACT_RANGE) + global_position
		var space_state = get_world_2d().direct_space_state
		var results = space_state.intersect_point(at, 1, [], CollisionLayers.EVENT_LAYER, false, true)
		var result = results[0] if results.size() > 0 else null
		if result:
			if result.collider is EventTrigger:
				if pet == result.collider.get_parent().get_parent():
					if pet.is_sleeping == false:
						pet.sit_label.visible = true
						pet.get_node("Event").set_outline_shader()
						pet.update_sit_label()
		else:
			pet.sit_label.visible = false
			pet.get_node("Event").unset_outline_shader()
	
	var mouse = get_global_mouse_position() - global_position
	var at = mouse.clamped(INTERACT_RANGE) + global_position
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(at, 1, [], CollisionLayers.EVENT_LAYER, false, true)
	var result = results[0] if results.size() > 0 else null
	if result:
		if result.collider is EventTrigger:
			if result.collider.get_parent().get_parent().is_in_group("Events"):
				var event = result.collider.get_parent().get_parent()
				if event.show_label:
					event.get_node("InteractLabel").visible = true
					event.set_outline_shader()
					to_interact_object = event.get_node("InteractLabel")
			elif result.collider.get_parent().is_in_group("Events"):
				var event = result.collider.get_parent()
				if event.show_label:
					event.get_node("InteractLabel").visible = true
					event.set_outline_shader()
					to_interact_object = event.get_node("InteractLabel")
	else:
		if to_interact_object != null:
			to_interact_object.visible = false
			to_interact_object.get_parent().unset_outline_shader()
			to_interact_object = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		var mouse = get_global_mouse_position() - global_position
		interact(mouse.clamped(INTERACT_RANGE) + global_position)

func _input(event):
	if PlayerInventory.current_item_type == "SpellBook" || PlayerInventory.current_item_type == "Tool" || PlayerInventory.current_item_type == "Weapon" && hand_item.can_attack:
		if event.is_action_pressed("mouse_left"):
			primary_attack()
		if event.is_action_pressed("mouse_right"):
			secondary_attack()
	if PlayerInventory.current_item_type == "Consumable":
		if event.is_action_pressed("mouse_left"):
			consume_item()
	if PlayerInventory.current_item_type == "FarmResource":
		if event.is_action_pressed("mouse_left"):
			plant_item()
	
	if (event.is_action_pressed("scroll_down") || event.is_action_pressed("scroll_up")) && PlayerInventory.can_change_item:
		update_hand_item()

func _update_move_input():
	if can_move:
		move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
		move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
		move_input = move_input.normalized()
	else:
		move_input = Vector2.ZERO

func _update_velocity():
	#lerp is to use knockback
	if !is_moving_towards:
		velocity = lerp(velocity, move_input * move_speed * 24, get_move_weight())
	else:
		move_towards(target_pos)

func _apply_movement():
	if can_move || is_moving_towards:
		velocity = move_and_slide(velocity)

func move_towards(to):
	var displacement = to - global_position
	var seek = displacement.normalized()
#	var avoidance = get_avoidance()
	var direction = seek # + avoidance
	velocity = lerp(velocity, direction * move_speed * 24, get_move_weight())

func _update_look():
	look = (get_global_mouse_position() - global_position).normalized()

func primary_attack():
	attack_cooldown.start(hand_item.cooldown)
	hand_item.primary_attack()
#	var attack_area = preload("res://Attack/AttackArea.tscn").instance()
#	add_child(attack_area)
#	var mouse = get_global_mouse_position() - global_position
#	attack_area.position = mouse.normalized() * HAND_RADIUS
#	attack_area.set_attacker(self)

func secondary_attack():
	attack_cooldown.start(hand_item.cooldown)
	hand_item.secondary_attack()

func consume_item():
	hand_item.consume_item(1)

func plant_item():
	hand_item.plant_item()

func _on_Hitbox_damaged(amount, knockback_strength, damage_scource, _attacker):
	PlayerStats.damaged()
	set_health(PlayerStats.health - amount)
	if damage_scource != null:
		knockback(knockback_strength, damage_scource.global_position)
	damage_animator.play("damage")
	if hitbox.immunity_duration != 0:
		damage_animator.queue("invulnerability")

func set_health(value):
	health = value
	PlayerStats.set_health(value)
	if PlayerStats.health <= 0:
		die()

func set_max_health(value):
	max_health = value
	PlayerStats.set_max_health(value)

func set_move_speed(value):
	move_speed = value
	PlayerStats.set_move_speed(value)

func idle():
	_update_look()
	animation_state.travel("Idle")
	foot_particles.emitting = false

func run():
	_update_move_input()
	animation_state.travel("Run")

func dodge():
	_update_move_input()
	match dodge_op:
		0: #normal dodge
			if dodge_cooldown.is_stopped() && move_input != Vector2.ZERO:
				#collisions and weapons
				hitbox_collision_shape.disabled = true
				if PlayerInventory.current_item_type == "Weapon" || PlayerInventory.current_item_type == "Tool":
					hand_item.can_attack = false
				hand_item.visible = false
				#velocity
				velocity = move_input * DODGE_VELOCITY
				#cooldowns
				dodge_timer.start(0.4)
				dodge_cooldown.start()
				var dodge_cooldown_bar = Globals.ui.dodge_bar.get_node("ProgressBar")
				var tween = Globals.ui.dodge_bar.get_node("Tween")
				tween.interpolate_property(dodge_cooldown_bar, "value", 0, 100, dodge_cooldown.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				#animation
				animation_state.travel("Dodge")
		1: #dash
			if dodge_cooldown.is_stopped() && move_input != Vector2.ZERO:
				#collisions and weapons
				hitbox_collision_shape.disabled = true
#				if PlayerInventory.current_item_type == "Weapon" || PlayerInventory.current_item_type == "Tool":
#					hand_item.can_attack = false
#				hand_item.visible = false
				#velocity
				velocity = move_input * pet.DASH_VELOCITY
				#cooldowns
				dodge_timer.start(0.2)
				dodge_cooldown.start()
				var dodge_cooldown_bar = Globals.ui.dodge_bar.get_node("ProgressBar")
				var tween = Globals.ui.dodge_bar.get_node("Tween")
				tween.interpolate_property(dodge_cooldown_bar, "value", 0, 100, dodge_cooldown.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				#animation
				animation_state.travel("Run")

func exit_dodge():
	hand_item.visible = true
	hitbox_collision_shape.disabled = false
	if PlayerInventory.current_item_type == "Weapon" || PlayerInventory.current_item_type == "Tool":
		hand_item.can_attack = true

func update_hand_item():
	if hand_item != null:
		pivot.remove_child(hand_item)
		hand_item.queue_free()
	if PlayerInventory.current_item_path != "Hand":
		var item_load = load(PlayerInventory.current_item_path)
		var item_instance = item_load.instance()
		pivot.add_child(item_instance)
		hand_item = pivot.get_node(item_instance.item_name)

func interact(at : Vector2):
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(at, 1, [], CollisionLayers.EVENT_LAYER, false, true)
	var result = results[0] if results.size() > 0 else null
	if result:
		if result.collider is EventTrigger:
			result.collider.on_triggered()

func update_skin():
	head_sprite.texture = skins.head_spritessheet[PlayerInventory.curr_head][1]
	body_sprite.texture = skins.body_spritessheet[PlayerInventory.curr_body][1]
	shoes_sprite.texture = skins.shoes_spritessheet[PlayerInventory.curr_shoes][1]

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
	
	Globals.ui.game_over()
