extends Camera2D

onready var top_left = $Limits/TopLeft
onready var bottom_right = $Limits/BottomRight

onready var wait_timer = $WaitTimer
onready var tween = $Tween

func _ready():
	Globals.camera = self
	
	limit_top = top_left.position.y
	limit_left = top_left.position.x
	limit_bottom = bottom_right.position.y
	limit_right = bottom_right.position.x

func slide_to(to: Vector2, slide_duration : float = 3, wait_time : float = 2):
	var initial_pos = Globals.player.position
	
	get_tree().paused = true
	
	Globals.player.get_node("RemoteTransform2D").update_position = false
	self.position = initial_pos
	
	tween.interpolate_property(self, "position", initial_pos, to, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	wait_timer.start(wait_time)
	yield(wait_timer, "timeout")
	tween.interpolate_property(self, "position", to, initial_pos, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	Globals.player.get_node("RemoteTransform2D").update_position = true
	
	get_tree().paused = false
