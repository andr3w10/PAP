extends Area2D


func _on_AIDetector_body_entered(body):
	if body != Globals.player:
		#is AI
		body.active_ai = false


func _on_AIDetector_body_exited(body):
	if body != Globals.player:
		#is AI
		body.active_ai = true
