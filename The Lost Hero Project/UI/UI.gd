extends CanvasLayer

onready var animation_player = $AnimationPlayer

onready var menu_ui = $Menu
onready var spellbook_ui = $SpellBookUI
onready var chest_ui = $ChestUI
onready var closet_ui = $ClosetUI
onready var pethouse_ui = $PetHouseUI
onready var hotbar_ui = $Hotbar
onready var stats_ui = $PlayerStatsUI
onready var dodge_bar = $DodgeBarUI
onready var date_time_ui = $DateTimeUI
onready var dialogue_manager = $DialogueManager
onready var top_text_display = $TopTextDisplay
onready var bot_text_display = $BotTextDisplay
onready var right_display_box = $RightDisplayBox
onready var boss_health_bar = $BossHealthBarUI
onready var game_over_ui = $GameOverUI

var holding_item = null

func _ready():
	Globals.ui = self

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()

func game_over():
	get_tree().paused = true
	Globals.can_open_menu = false
	animation_player.play("show_game_over")
