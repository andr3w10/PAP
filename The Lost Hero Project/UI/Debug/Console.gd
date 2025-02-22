extends Control

var temp = 1

onready var input_box = get_node("input")
onready var output_box = get_node("output")

var command_history_line = DebugCommandsHistory.history.size()

func _ready():
	input_box.grab_focus()
	yield(get_tree().create_timer(0.1), "timeout")
	input_box.clear()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_debug_console"):
		#prevent delete ir on first click
		if temp == 1:
			temp = 0
		else:
			get_tree().paused = false
			Globals.can_open_menu = true
			PlayerInventory.can_change_item = true
			self.queue_free()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			goto_command_history(-1)
		if event.scancode == KEY_DOWN:
			goto_command_history(1)

func goto_command_history(offset):
	command_history_line += offset
	command_history_line = clamp(command_history_line, 0, DebugCommandsHistory.history.size())
	if command_history_line < DebugCommandsHistory.history.size() and DebugCommandsHistory.history.size() > 0:
		input_box.text = DebugCommandsHistory.history[command_history_line]
		input_box.call_deferred("set_cursor_position", 9999999)

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	for _i in range(words.count("")):
		words.erase("")
	
	if words.size() == 0:
		return
	
	DebugCommandsHistory.history.append(text)
	
	var command_word = words.pop_front()
	
	for c in CommandHandler.valid_commands:
		if c[0] == command_word:
			if words.size() != c[1].size():
				#error in num of params
				output_text(str('Failure executing command "', command_word, '", expected ', c[1].size(), ' parameters'))
				return
			for i in range(words.size()):
				if not check_type(words[i], c[1][i]):
					#error in parameter type
					output_text(str('Failure executing command "', command_word, ', parameter ', (i+1), ' ("', words[i], '") is of the wrong type'))
					return
			#is correct
			output_text(CommandHandler.callv(command_word, words))
			return
	#dont exists
	output_text(str('Command "', command_word, '" does not exist'))

func check_type(string, type):
	if type == CommandHandler.ARG_INT:
		return string.is_valid_integer()
	if type == CommandHandler.ARG_FLOAT:
		return string.is_valid_float()
	if type == CommandHandler.ARG_STRING:
		return true
	if type == CommandHandler.ARG_BOOL:
		return (string == "true" or string == "false")
	return false

func output_text(text):
	output_box.text = str(output_box.text, "\n", text)
	output_box.set_v_scroll(9999999)

func _on_input_text_entered(new_text):
	input_box.clear()
	process_command(new_text)
	command_history_line = DebugCommandsHistory.history.size()
