class_name ProjectileLauncher
extends Node2D

class Params:
	var mouse_pos: Vector2
	var parent: Node2D
	var count: int
	var hit_callback

	func _init(mouse_pos: Vector2, parent: Node2D, count: int = 1, hit_callback = null):
		self.mouse_pos = mouse_pos
		self.parent = parent
		self.count = count
		self.hit_callback = hit_callback


@export var launch_speed: float = 100
@export var launch_delay: float = 0.25
@export var launch_sound: String = "launch"

@onready var line: Line2D = $Line2D

signal projectile_launched(projectile: Projectile)

var _projectiles: Array[Projectile] = []
var projectile_scene = preload("res://scenes/game/projectile.tscn")
var _show_line: bool = false

func _process(delta: float) -> void:
	if _show_line:
		# TODO: Not hardcoded
		line.points = [Vector2.ZERO, (get_global_mouse_position() - self.global_position).clamp(Vector2(-4000, 4), Vector2(4000, 4000))]
	else:
		line.points = []

func show_line() -> void:
	_show_line = true

func hide_line() -> void:
	_show_line = false

func launch_multiple(params: Params) -> Array[Projectile]:
	var projectiles: Array[Projectile] = []
	var projectile
	for i in range(params.count):
		# Create a new projectile if needed
		if i >= projectiles.size():
			projectile = _create_projectile()
			_projectiles.append(projectile)

		# Reuse an existing projectile
		projectile = _projectiles[i]
		projectiles.append(projectile)
		params.parent.add_child(projectile)
		
		# Launch the projectile
		projectile.global_position = self.global_position
		projectile.linear_velocity = Vector2(params.mouse_pos - self.global_position).normalized() * launch_speed
		projectile.gravity_scale = 0
		projectile.visible = true

		if !projectile.is_connected("hit", params.hit_callback):
			projectile.connect("hit", params.hit_callback)

		emit_signal("projectile_launched", projectile)
		AudioManager.play(launch_sound)
		await get_tree().create_timer(launch_delay).timeout
	return projectiles

func _create_projectile() -> Projectile:
	var projectile = projectile_scene.instantiate() as Projectile
	return projectile
