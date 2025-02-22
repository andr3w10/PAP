extends KinematicBody2D

const ACCELERATION = 2500
const MAX_SPEED = 800
var velocity = Vector2.ZERO

export var range_to_pickup = 5

export var item_name : String = ""

onready var animation_player = $AnimationPlayer
onready var item_audio_stream_player = $ItemPickAudioStreamPlayer

var type = "wood"

var player = null
var being_picked_up = false

func _physics_process(delta):
	if PlayerInventory.wood < PlayerInventory.max_wood:
		if being_picked_up == true:
			var direction = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			var distance = global_position.distance_to(player.global_position)
			if distance <= range_to_pickup:
				var wood_quantity = int(JsonData.item_data[item_name]["WoodQuantity"])
				PlayerInventory.add_wood(wood_quantity)
				queue_free()
		
		velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
	item_audio_stream_player.play()

func item_droped():
	animation_player.play("Float")
