extends CanvasLayer

signal scene_changed
signal faded_in

onready var animation_player = $AnimationPlayer
onready var transitions = $Transitions

func change_the_scene(path, delay = 0, send_signal_faded_in = false):
	yield(get_tree().create_timer(delay), "timeout")
	transitions.visible = true
	animation_player.play("black_circle")
	yield(animation_player, "animation_finished")
	var _value = get_tree().change_scene(path)
	if send_signal_faded_in == true:
		emit_signal("faded_in")
	animation_player.play_backwards("black_circle")
	yield(animation_player, "animation_finished")
	transitions.visible = false
	emit_signal("scene_changed")
