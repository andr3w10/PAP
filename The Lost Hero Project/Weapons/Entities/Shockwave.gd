extends Node2D

const Entity = preload("res://Weapons/Entities/ShockwaveEntity.tscn")
const ENTITY_SPACING = 8.0
const ENTITY_TIMING = 0.05
const ENTITY_LIFETIME = 0.4

onready var tween = $Tween

func _ready():
	spawn_entities()
	
func spawn_entities():
	for i in 8:
		tween.interpolate_callback(self, i * ENTITY_TIMING, "spawn_entity", i)
	tween.start()

func spawn_entity(idx : int):
	var entity = Entity.instance()
	$Entities.add_child(entity)
	entity.position.x = ENTITY_SPACING * idx
	entity.connect("tree_exited", self, "_on_entity_removed")

func _on_entity_removed():
	if $Entities.get_child_count() == 0:
		queue_free()
