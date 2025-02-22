extends ColorRect

const CHANGE_LIGHT_TIME : float = 3600.0

export (NodePath) var camera_path

onready var tween = DayNightTween

var image = Image.new()
var texture = ImageTexture.new()

var aux : int = -1

func _ready():
# warning-ignore:return_value_discarded
	DateTime.connect("change_day", self, "no_delay_day")
# warning-ignore:return_value_discarded
	DateTime.connect("change_night", self, "no_delay_night")
# warning-ignore:return_value_discarded
	DateTime.connect("change_day_night", self, "day_night")
# warning-ignore:return_value_discarded
	DateTime.connect("change_night_day", self, "night_day")
	#show
	image.create(128, 2, false, Image.FORMAT_RGBAH)

# warning-ignore:unused_argument
func _physics_process(delta):
	_update_texture()
	var t = Transform2D(0, Vector2())
	var camera = get_node_or_null(camera_path)
	if camera != null:
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale()
		t = Transform2D(0, top_left)
	material.set_shader_param("global_transform", t)

func _update_texture():
	# Get all light sources in the level
	var lights = get_tree().get_nodes_in_group("Lights")
	# Assign values to the texture
	image.lock()
	for i in lights.size():
		var light = lights[i]
		if light is LightSource:
			# Store the x and y position in the red and green channels
			# How luminious the light is in the blue channel
			# And the light's radius in the alpha channel
			var light_position = light.global_position.floor()
			image.set_pixel(i, 0, Color( \
					light_position.x, light_position.y, \
					light.strength, light.radius))
			# Store the light's color in the 2nd row
			image.set_pixel(i, 1, light.color)
	image.unlock()
	
	texture.create_from_image(image)
	
	material.set_shader_param("n_lights", lights.size())
	material.set_shader_param("light_data", texture)

func no_delay_day():
# warning-ignore:return_value_discarded
	DayNightTween.remove_all()
	self.material.set_shader_param("light_level", 1.0)

func no_delay_night():
# warning-ignore:return_value_discarded
	DayNightTween.remove_all()
	self.material.set_shader_param("light_level", 0.0)

func day_night():
	if !tween.is_active() && DateTime.hour != aux:
		aux = DateTime.hour
		tween.interpolate_property(self.material, "shader_param/light_level", 1.0, 0.0, (CHANGE_LIGHT_TIME / DateTime.TIME_SPEED), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
		tween.start()

func night_day():
	if !tween.is_active() && DateTime.hour != aux:
		aux = DateTime.hour
		tween.interpolate_property(self.material, "shader_param/light_level", 0.0, 1.0, (CHANGE_LIGHT_TIME / DateTime.TIME_SPEED), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
		tween.start()
