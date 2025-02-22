extends CanvasLayer

var stats = []

func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug_console"):
		add_child(load("res://UI/Debug/Console.tscn").instance())
		get_tree().paused = true
		Globals.can_open_menu = false
		PlayerInventory.can_change_item = false

func add_stat(stat_name, object, stat_ref, is_method):
	stats.append([stat_name, object, stat_ref, is_method])

func _process(_delta):
	if !Globals.show_debug:
		get_node("Label").visible = false
		return
	
	
	var label_text = ""
	
	####### Predefined Stats #######
	var fps = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps)
	label_text += "\n"
	
	var mem = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(mem))
	label_text += "\n"
	
	var position = Globals.player.position
	var x = position.x
	x = round(x * pow(10.0, 2)) / pow(10.0, 2)
	var y = position.y
	y = round(y * pow(10.0, 2)) / pow(10.0, 2)
	label_text += str("Player Position: (", x, ", ", y, ")")
	label_text += "\n"
	
	var health = Globals.player.health
	label_text += str("Player Health: ", health)
	label_text += "\n"
	
	var move_speed = Globals.player.move_speed
	label_text += str("Player Move Speed: ", move_speed)
	label_text += "\n"
	################################
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		
		label_text += str(s[0], ": ", value)
		label_text += "\n"
	
	$Label.text = label_text
	get_node("Label").visible = true
