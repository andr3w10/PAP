extends Node2D


onready var tween = $Tween
onready var attack_animator = $AttackAnimator
onready var pivot = $Pivot
onready var basic_cooldown_timer = $BasicCooldown
onready var special_cooldown_timer = $ChangeCooldown

onready var mouse_cursor = $CustomCursors

var spellbook = null

var cooldown_timer = null #setted on each weapon

export var item_name = ""

#export var radius = 8.0
var basic_cooldown = 0.3
var special_cooldown = 2
var basic_duration = 0.2
var special_duration = 0.2
var item_type = ""
var max_spells

var current_spell = ""

var cooldown = 0
var attack_duration = 0.2

var swipe = -1.0

var can_attack = true

func _ready():
#	rotation = -PI / 2.0 * -sign(swipe)
#	pivot.rotation = PI / 3.5 * sign(swipe)
	var maximum_spells = float(JsonData.item_data[item_name]["MaxSpells"])
	max_spells = maximum_spells
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

func _process(_delta):
	if current_spell == "splash":
		if !mouse_cursor.get_node("splash").visible:
			mouse_cursor.get_node("splash").visible = true
		mouse_cursor.global_position = get_global_mouse_position()

func _on_spell_changed():
	for i in mouse_cursor.get_children():
		i.visible = false
	current_spell = spellbook.curr_spell_cast

func primary_attack():
	if basic_cooldown_timer.is_stopped():
		cooldown_timer = basic_cooldown_timer
		cooldown = basic_cooldown
		attack_duration = basic_duration
		
		if current_spell != "":
			var spell = funcref(self, current_spell)
			spell.call_func()
			start_cooldown()
		else:
			Globals.map.ui.bot_text_display.show_text("You need to select a spell", 5.0, 0.8, 10)

func secondary_attack():
	if special_cooldown_timer.is_stopped():
		current_spell = spellbook.curr_spell_cast
		
		spellbook.open_spellbook()
		
		cooldown_timer = special_cooldown_timer
		cooldown = special_cooldown
		attack_duration = special_duration

		#TODO: only start the colldowns if the player select a spell
		start_cooldown()

func start_cooldown():
	#start cooldown
	cooldown_timer.start(cooldown + attack_duration)


#SPELLS
func fireball():
#	Globals.map.ui.bot_text_display.show_text("You casted a fireball", 5.0, 0.8, 10)
	var fireball = preload("res://Weapons/Entities/Fireball.tscn").instance()
	var normal = (get_global_mouse_position() - pivot.global_position).normalized()
	fireball.set_direction(normal, "enemy", 8*24)
	Globals.map.add_entity(fireball)
	fireball.global_position = pivot.global_position

func splash():
#	Globals.map.ui.bot_text_display.show_text("You casted a water wave", 5.0, 0.8, 10)
	var attack_splash = load("res://Attack/WaterSplash.tscn").instance()
	Globals.map.add_entity(attack_splash)
	attack_splash.global_position = get_global_mouse_position()
	attack_splash.attack("enemy", null, false)

func bush():
	Globals.map.ui.bot_text_display.show_text("You created a bush", 5.0, 0.8, 10)

func rock():
#	Globals.map.ui.bot_text_display.show_text("You created a rock", 5.0, 0.8, 10)
	Globals.player.can_move = false
	var shockwave = load("res://Attack/Shockwave.tscn").instance()
	Globals.map.add_entity(shockwave)
	shockwave.global_position = Globals.player.global_position
	shockwave.attack("enemy", self, 1)

func thunder():
	Globals.map.ui.bot_text_display.show_text("You casted a thunder", 5.0, 0.8, 10)

func wind_blast():
	Globals.map.ui.bot_text_display.show_text("You casted a wind blast", 5.0, 0.8, 10)

func light_beam():
	Globals.map.ui.bot_text_display.show_text("You casted a light beam", 5.0, 0.8, 10)

func mind_control():
	Globals.map.ui.bot_text_display.show_text("You have controlled enemy mind", 5.0, 0.8, 10)

func teleport():
	Globals.map.ui.bot_text_display.show_text("You have teleported", 5.0, 0.8, 10)


func _on_temp_load_timeout():
	spellbook = Globals.ui.spellbook_ui
	spellbook.connect("spell_changed", self, "_on_spell_changed")
	current_spell = spellbook.curr_spell_cast


func _shockwave_completed():
	Globals.player.can_move = true
