extends Control

const PORTRAITS_PATH = "res://PixelArt/Characters/Portraits/"

signal advanced
signal responded
signal finished
signal accepted
signal canceled

export (float) var textSpeed = 0.05

onready var animation_player = get_parent().get_node("AnimationPlayer")
onready var dialogue_box = $DialogueBox
onready var dialogue_text = $DialogueBox/DialogueText
onready var portrait_box = $Portrait
onready var name_label = $Name
onready var yesno = $Btns/YesNo
onready var responses_ui = $ResponsesUI
onready var next = $Btns/Next
onready var timer = $TextSpeed

var is_opened : bool = false

var need_confirmation : bool = false
var need_response : bool = false
var is_canceled : bool = false

var current_response_idx = 0
var max_response_idx = 0

var all_text_visible := true

func _ready():
	hide()
	visible = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if all_text_visible:
			if !need_confirmation:
				next.visible = false
				emit_signal("advanced")
		else:
			dialogue_text.visible_characters = len(dialogue_text.text)
			next.visible = true
	
	if need_response:
		if event.is_action_pressed("arrow_up"):
			if current_response_idx >= max_response_idx:
				current_response_idx = 1
			else:
				current_response_idx += 1
			
			update_resposnse_ui()
			
		if event.is_action_pressed("arrow_down"):
			if current_response_idx <= 1:
				current_response_idx = max_response_idx
			else:
				current_response_idx -= 1
			
			update_resposnse_ui()
		
		if event.is_action_pressed("ui_accept"):
			emit_signal("responded")
	

func init_dialogue(id : String):
	get_tree().paused = true
	get_parent().get_node("Hotbar").visible = false
	visible = true
	animation_player.play("open_dialogue_ui")
	is_opened = true
	
	#load the data from the json file
	var file = File.new()
	file.open("res://UI/Dialogue/DialogueText.json", File.READ)
	var data = parse_json(file.get_as_text())
	if data.has(id):
		var section = data[id]
		var type = section.type
		match type:
			"dialogue":
				need_confirmation = false
				need_response = false
				show_message(section)
			"response":
				need_confirmation = false
				need_response = true
				show_message_response(section)
			"confirmation":
				need_confirmation = true
				need_response = false
				show_message_confirm(section)
			
		if !is_canceled:
			yield(self, "advanced")
		
		if section.keys().has("commands"):
			execute_dialogue_commands(section.commands)
		
		while section.keys().has("next") || section.keys().has("responses"):
			if section.keys().has("next"):
				section = data[section.next]
			elif section.keys().has("responses"):
				var cont = 1
				for response in section.responses:
					if cont == current_response_idx:
						if section.responses[response].keys().has("commands"):
							execute_dialogue_commands(section.responses[response].commands)
						section = data[section.responses[response]["next"]]
					cont += 1
			
			type = section.type
			match type:
				"dialogue":
					need_confirmation = false
					need_response = false
					show_message(section)
				"response":
					need_confirmation = false
					need_response = true
					show_message_response(section)
				"confirmation":
					need_confirmation = true
					need_response = false
					show_message_confirm(section)
			
			if !is_canceled:
				yield(self, "advanced")
			
			if section.keys().has("commands"):
				execute_dialogue_commands(section.commands)
	
	#finished the dialogue
	close_dialogue()

func show_message(section):
	dialogue_text.rect_size.y = 72
	dialogue_text.margin_bottom = -16
	yesno.visible = false
	responses_ui.visible = false
	next.visible = false
	
	var formated_text = format_text(section.text)
	
	dialogue_text.bbcode_text = formated_text
	
	var char_name = section.speaker_id
	if char_name == "":
		char_name = "Unknown"
	var portrait_id = section.portrait_id
	if portrait_id == "":
		portrait_id = "neutral"
	
	name_label.text = char_name
	
	var portrait_path = "res://PixelArt/Characters/Portraits/" + char_name + "_" + portrait_id + ".png"
	var directory = Directory.new();
	var fileExists = directory.file_exists(portrait_path)
	if !fileExists:
		portrait_path = "res://PixelArt/Characters/Portraits/Unknown_neutral.png"
	
	portrait_box.texture = load(portrait_path)
	
	
	#text animation
	timer.wait_time = textSpeed
	dialogue_text.visible_characters = 0
	all_text_visible = false
	while dialogue_text.visible_characters < len(dialogue_text.text):
		dialogue_text.visible_characters += 1
		#TODO: add sfx
		timer.start()
		yield(timer, "timeout")
	
	all_text_visible = true
	next.visible = true

func show_message_response(section):
	dialogue_text.rect_size.y = 72
	dialogue_text.margin_bottom = -16
	yesno.visible = false
	responses_ui.visible = false
	next.visible = false
	
	var formated_text = format_text(section.text)
	
	dialogue_text.bbcode_text = formated_text
	
	var char_name = section.speaker_id
	if char_name == "":
		char_name = "Unknown"
	var portrait_id = section.portrait_id
	if portrait_id == "":
		portrait_id = "neutral"
	
	name_label.text = char_name
	
	var portrait_path = "res://PixelArt/Characters/Portraits/" + char_name + "_" + portrait_id + ".png"
	var directory = Directory.new();
	var fileExists = directory.file_exists(portrait_path)
	if !fileExists:
		portrait_path = "res://PixelArt/Characters/Portraits/Unknown_neutral.png"
	
	portrait_box.texture = load(portrait_path)
	
	
	#text animation
	timer.wait_time = textSpeed
	dialogue_text.visible_characters = 0
	all_text_visible = false
	while dialogue_text.visible_characters < len(dialogue_text.text):
		dialogue_text.visible_characters += 1
		#TODO: add sfx
		timer.start()
		yield(timer, "timeout")
	
	all_text_visible = true
	responses_ui.visible = true
	next.visible = false
	
	var responses_text = section.responses
	max_response_idx = responses_text.size()
	current_response_idx = max_response_idx
	
	update_resposnse_ui()
	
	for i in responses_ui.get_children():
		i.visible = false
	
	for i in range(responses_text.size()):
		var response = responses_ui.get_node(str(i+1))
		response.visible = true
		var cont = 1
		for text in responses_text:
			if cont == i+1:
				response.bbcode_text = format_text(text)
			cont += 1

func show_message_confirm(section):
	dialogue_text.rect_size.y = 56
	dialogue_text.margin_bottom = -32
	yesno.visible = false
	responses_ui.visible = false
	next.visible = false
	
	var formated_text = format_text(section.text)
	
	dialogue_text.bbcode_text = formated_text
	
	var char_name = section.speaker_id
	if char_name == "":
		char_name = "Unknown"
	var portrait_id = section.portrait_id
	if portrait_id == "":
		portrait_id = "neutral"
	
	name_label.text = char_name
	
	var portrait_path = "res://PixelArt/Characters/Portraits/" + char_name + "_" + portrait_id + ".png"
	var directory = Directory.new();
	var fileExists = directory.file_exists(portrait_path)
	if !fileExists:
		portrait_path = "res://PixelArt/Characters/Portraits/Unknown_neutral.png"
	
	portrait_box.texture = load(portrait_path)
	
	#text animation
	timer.wait_time = textSpeed
	dialogue_text.visible_characters = 0
	all_text_visible = false
	while dialogue_text.visible_characters < len(dialogue_text.text):
		dialogue_text.visible_characters += 1
		#TODO: add sfx
		timer.start()
		yield(timer, "timeout")
	
	all_text_visible = true
	next.visible = true
	yesno.visible = true

func close_dialogue():
	animation_player.play("close_dialogue_ui")
	yield(animation_player, "animation_finished")
	get_parent().get_node("Hotbar").visible = true
	get_tree().paused = false
	visible = false
	emit_signal("finished")
	is_opened = false
	is_canceled = false


func _on_YesBtn_pressed():
	next.visible = false
	emit_signal("advanced")
	emit_signal("accepted")

func _on_NoBtn_pressed():
	is_canceled = true
	next.visible = false
	emit_signal("advanced")
	emit_signal("canceled")

func connect_signal(signal_name, node, function):
	var _value
	_value = connect(signal_name, node, function)


func _on_Next_pressed():
	next.visible = false
	emit_signal("advanced")

func update_resposnse_ui():
	for i in responses_ui.get_children():
		i.get_node("Sprite").visible = false
	
	responses_ui.get_node(str(current_response_idx)).get_node("Sprite").visible = true


func init_premade_message(text):
	get_tree().paused = true
	get_parent().get_node("Hotbar").visible = false
	visible = true
	animation_player.play("open_dialogue_ui")
	is_opened = true
	
	#show message
	dialogue_text.rect_size.y = 72
	dialogue_text.margin_bottom = -16
	yesno.visible = false
	responses_ui.visible = false
	next.visible = false
	
	var formated_text = format_text(text)
	
	dialogue_text.bbcode_text = formated_text
	
	name_label.text = "Unknown"
	
	var portrait_path = "res://PixelArt/Characters/Portraits/Unknown_neutral.png"
	var directory = Directory.new();
	var fileExists = directory.file_exists(portrait_path)
	if !fileExists:
		portrait_path = "res://PixelArt/Characters/Portraits/Unknown_neutral.png"
	
	portrait_box.texture = load(portrait_path)
	
	
	#text animation
	timer.wait_time = textSpeed
	dialogue_text.visible_characters = 0
	all_text_visible = false
	while dialogue_text.visible_characters < len(dialogue_text.text):
		dialogue_text.visible_characters += 1
		#TODO: add sfx
		timer.start()
		yield(timer, "timeout")
	
	all_text_visible = true
	next.visible = true
	
	
	if !is_canceled:
		yield(self, "advanced")
	
	#finished the dialogue
	close_dialogue()


func format_text(text):
	var formated_text = text.format({"player": Globals.player_name})
	return formated_text


func execute_dialogue_commands(commands):
	for command in commands:
		process_command(command)

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

func output_text(_text):
#	print(text)
	pass
