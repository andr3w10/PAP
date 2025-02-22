extends Node

const DEFAULT_BACKGROUND = preload("res://Others/Music/default.wav")

onready var button_hover_audio_player_stream = $Interface/ButtonHoverAudioStreamPlayer
onready var button_click_audio_player_stream = $Interface/ButtonClickAudioStreamPlayer

onready var music = get_node("Music")

func play_menu_hover():
	button_hover_audio_player_stream.play()

func play_menu_click():
	button_click_audio_player_stream.play()


func play_background():
	if !music.stream == DEFAULT_BACKGROUND:
		music.stream = DEFAULT_BACKGROUND
		music.playing = true


func _on_Music_finished():
	music.playing = true
