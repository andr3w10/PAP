extends CanvasLayer

onready var move_button = $TouchScreenMoveButton

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if move_button.is_pressed():
			var move_vector = calculate_move_vector(event.position, move_button)
			print(move_vector)

func calculate_move_vector(event_position, button):
	var texture_center = button.position + Vector2(16,16)
	return (event_position - texture_center).normalized()
