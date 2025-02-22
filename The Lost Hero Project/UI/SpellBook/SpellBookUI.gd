extends Control

signal spell_changed

var base = preload("res://PixelArt/MagicElements/base.png")
var base_empty = preload("res://PixelArt/MagicElements/base_empty.png")

onready var spells_ui = $Spells
onready var selected_spell_ui = $SelectedSpell

var is_opened : bool = false

var curr_spell_duration : float = 0
var curr_spell_cooldown : float = 0
var curr_spell_cast : String = ""

func _input(event):
	if event.is_action_pressed("menu"):
		if is_opened:
			close_spellbook()
		

func open_spellbook():
	if Globals.can_open_menu:
		Globals.can_open_menu = false
		PlayerInventory.can_change_item = false
		get_tree().paused = true
		Globals.ui.get_node("Hotbar").visible = false
		Globals.ui.get_node("PlayerStatsUI").visible = false
		Globals.ui.get_node("DateTimeUI").visible = false
		Globals.ui.get_node("DodgeBarUI").visible = false
		Globals.ui.get_node("AnimationPlayer").play("open_spellbook")
		Globals.ui.get_node("Background").visible = true
		self.visible = true
		update_textures()

func close_spellbook():
	Globals.ui.get_node("AnimationPlayer").play("close_spellbook")

func menu_is_opened():
	is_opened = true

func menu_is_closed():
	PlayerInventory.can_change_item = true
	get_tree().paused = false
	Globals.ui.get_node("Hotbar").visible = true
	Globals.ui.get_node("PlayerStatsUI").visible = true
	Globals.ui.get_node("DateTimeUI").visible = true
	Globals.ui.get_node("DodgeBarUI").visible = true
	Globals.ui.get_node("Background").visible = false
	self.visible = false
	is_opened = false
	Globals.can_open_menu = true


func update_textures():
	var spells = PlayerInventory.spells
	for spell in spells:
		if spells[spell][1] == 0:
			spells_ui.get_node(spells[spell][0]).get_node("Icon").disabled = true
		elif spells[spell][1] == 1:
			spells_ui.get_node(spells[spell][0]).get_node("Icon").disabled = false
	
	for child in spells_ui.get_children():
		if child.get_node("Icon").disabled:
			child.texture = base_empty
		else:
			child.texture = base


func select_spell(spell):
	var spells_data = JsonData.LoadData("res://Inventory/Items/Data/SpellsData.json")
	var spell_img = $SelectedSpell/SpellImg
	spell_img.texture = load("res://PixelArt/MagicElements/" + spell + ".png")
	get_node("SelectedSpell/SpellName").text = spell + "\nSpell"
	curr_spell_duration = spells_data[spell]["SpellDuration"]
	curr_spell_cooldown = spells_data[spell]["SpellCooldown"]
	var description = spells_data[spell]["Description"]
	curr_spell_cast = spells_data[spell]["Cast"]
	get_node("SelectedSpell/SpellDescription").text = description
	
	get_node("SelectedSpell").visible = true
	get_node("AnimationPlayer").play("show_selected_spell")
	
	emit_signal("spell_changed")


func _on_fire_pressed():
	select_spell("Fire")


func _on_water_pressed():
	select_spell("Water")


func _on_grass_pressed():
	select_spell("Grass")


func _on_earth_pressed():
	select_spell("Earth")


func _on_thunder_pressed():
	select_spell("Thunder")


func _on_wind_pressed():
	select_spell("Wind")


func _on_light_pressed():
	select_spell("Light")


func _on_psychic_pressed():
	select_spell("Psychic")


func _on_shadow_pressed():
	select_spell("Shadow")
