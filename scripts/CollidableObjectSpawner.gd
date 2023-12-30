class_name CollidableObjectSpawner

extends Node2D

@export var spawn_count_min: int = 1
@export var spawn_count_max: int = 3
@export var spawn_location_prefix: String = "spawn_location_"
@export var spawnable_objects: Array[PackedScene] = []
@export var spawn_parent: Node2D = null

var _spawn_locations: Array = []

func _ready():
	if spawn_parent == null:
		spawn_parent = get_parent()
	for child in get_children():
		if child.name.begins_with(spawn_location_prefix):
			_spawn_locations.append(child)
			
func spawn(health: int = 1) -> Array:
	var randomSpawnLocations = _spawn_locations.duplicate()
	randomSpawnLocations.shuffle()
	var spawn_count = randi() % (spawn_count_max - spawn_count_min + 1) + spawn_count_min
	var spawned: Array[CollidableObject] = []
	for i in range(spawn_count):
		var spawn_location = randomSpawnLocations[i]
		var spawn_scene = spawnable_objects[randi() % spawnable_objects.size()]
		var spawn = spawn_scene.instantiate() as CollidableObject
		spawn.health = health
		spawn_parent.add_child(spawn)
		spawn.position = spawn_location.position
		spawn.random_rotation()
		spawned.append(spawn)
	return spawned
