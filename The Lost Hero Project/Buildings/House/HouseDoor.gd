extends Node2D

const FADE_DURATION := 0.25

#export (int) var house_num = 0

#onready var roof = get_parent().get_parent().get_node("HouseRoofs/HouseRoof" + str(house_num))
#onready var tween = $Tween

func _on_CharacterDetector_body_entered(body):
	body.is_detectable = false
	
#	self.modulate = Color(1, 1, 1, 0)
#	self.visible = false
	self.animation = "opened"
	
#	tween.interpolate_property(roof, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), FADE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()

func _on_CharacterDetector_body_exited(body):
	body.is_detectable = true
	
#	self.modulate = Color(1, 1, 1, 1)
#	self.visible = true
	self.animation = "closed"
	
#	tween.interpolate_property(roof, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), FADE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
