extends Node

const password = "thelosthero"
const SAVE_DIR = "user://Saves/"

const START_SCENE_PATH_NAME = "TutorialLevel"

const MAX_SAVES = 3

var player = null
#var player_initial_position = Vector2(-1470, -170)
var player_initial_position = Vector2(-700, -80)

var time = 0

var level = null
var map = null
var ui = null
var camera = null

var current_boss = null

var can_open_menu : bool = true

var player_name : String = "Hero"

var current_story : int = 1
var account_type = 1 #if 1 in online, if 0 is offline

var account_username = "admin"

var change_light : bool = true

var show_debug : bool = true

func _ready():
	randomize()

func _process(delta):
	time += delta
