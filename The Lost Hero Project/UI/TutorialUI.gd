extends Control

onready var move_ui = $Move
onready var interact_ui = $Interact
onready var dodge_ui = $Dodge
onready var menu_ui = $Menu
onready var primary_attack_ui = $PrimaryAttack
onready var secondary_attack_ui = $SecondaryAttack
onready var hotbar_ui = $Hotbar
onready var save_game_ui = $SaveGame
onready var completed_ui = $Completed

var move_text = "Use this keys to move the player in the map"
var interact_text = "Use interact key to interact with chests, signs, NPC's, ... You need to be close to the object and your mouse need to be over it to interact"
var dodge_text = "Use the dodge key to avoid enemy attacks and to move a bit faster... This ability have a cooldown, so be careful (you need to be running)"
var menu_text = "Open the menu to have access to the inventory, settings, ..."
var primary_attack_text = "Use the primary attack if you want to make it faster and lighter... Each weapon has its own abilities and cooldowns"
var secondary_attack_text = "You can use a secondary attack to heaviest ones,but they are also more slow to load. Each weapon has its own abilities and cooldowns"
var hotbar_text = "Change the hand item switching the selected hotbar slot"
var save_game_text = "To save the game you need to find one of this buildings in the map and stay on them... The game will alert you when it's saved!"
var completed_text = "TUTORIAL COMPLETED SUCCESSFULY !!!"
