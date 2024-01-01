extends Node2D

@export var shine_time: float = 0.75
@export var shine_start_min: float = 60.0
@export var shine_start_max: float = 300.0

@onready var solid: Sprite2D = $Solid
@onready var timer: SceneTreeTimer = null

var tween: Tween = null

const SHINE_PROGRESS = "shine_progress"
const SHINE_SIZE = "shine_size"

func _process(delta):
	_random_shine()

func _random_shine():
	_time_and_shine(randf_range(shine_start_min, shine_start_max))

func _time_and_shine(time: float):
	if timer == null:
		print("Shine in " + str(time) + " seconds")
		timer = get_tree().create_timer(time)
		await timer.timeout
		await shine()
		timer = null

func shine():
	if tween == null:
		print("Bright and shiny!")
		tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_method((func(value): set_shader_value(solid, SHINE_PROGRESS, value)), 0.0, 1.0, shine_time)
		tween.tween_method((func(value): set_shader_value(solid, SHINE_SIZE, value)), 0.13, 0.01, shine_time * 0.75)
		# tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# tween.tween_method((func(value): set_shader_value(solid, SHINE_PROGRESS, value)), 1.0, 0.0, shine_time)
		# tween.tween_method((func(value): set_shader_value(solid, SHINE_SIZE, value)), 0.01, 0.13, shine_time)
		await tween.finished
		tween = null

func set_shader_value(textureObject, name, value):
	textureObject.material.set_shader_parameter(name, value);