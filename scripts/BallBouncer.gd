class_name BallBouncer
extends Node2D

@onready var camera = $Camera2D
@onready var object_container = $Objects
@onready var projectileLauncher: ProjectileLauncher = $ProjectileLauncher
@onready var collidableObjectSpawner: CollidableObjectSpawner = $CollidableObjectSpawner
@onready var deadZone: Area2D = $World/DeadZone
@onready var ui = $UI
@onready var gameOverScreen = $UI/GameOverScreen

@export var object_move_distance: float = 100.0
@export var object_move_duration: float = 0.5
@export var projectile_count: int = 0
@export var starting_round: int = 0

signal has_loaded

var score = 0
var high_score = 0
var projectiles_count = 0
var round_projectile_count = 0
var round = 0
var _has_shot = false
var _is_game_over = false
var cursor_event_position = Vector2.ZERO

func _ready():
	deadZone.body_entered.connect(_on_projectile_enter_dead_zone)
	projectileLauncher.projectile_launched.connect(on_projectile_launched)
	load_game()
	emit_signal("has_loaded")
	# _reset()

func _reset():
	score = 0
	_is_game_over = false
	projectiles_count = projectile_count
	round = starting_round
	ui.set_score(score)
	for child in object_container.get_children():
		if child is CollidableObject or child is Projectile:
			object_container.remove_child(child)
			child.queue_free()

func load_game():
	var save_file = FileAccess.open("user://save_game.save", FileAccess.READ)
	if save_file:
		var save_data = JSON.parse_string(save_file.get_as_text())
		high_score = save_data["high_score"]
	gameOverScreen.set_high_score(high_score)

func save_game():
	var save_file = FileAccess.open("user://save_game.save", FileAccess.WRITE)
	if score > high_score:
		high_score = score
	var save_data = {
		"high_score": high_score
	}
	save_file.store_line(JSON.stringify(save_data))

func get_launcher_target_position():
	return get_global_mouse_position()

func _launch_projectiles():
	if !_has_shot:
		_has_shot = true
		projectileLauncher.hide_line()
		round_projectile_count = projectiles_count
		var mouse_pos = get_launcher_target_position()
		var projectiles = await projectileLauncher.launch_multiple(ProjectileLauncher.Params.new(mouse_pos, object_container, projectiles_count, _on_projectile_hit))
		
func _on_projectile_enter_dead_zone(body):
	var projectile = body as Projectile
	if projectile:
		projectile.gravity_scale = 0
		projectile.linear_velocity = Vector2.ZERO
		projectile.visible = false
		_on_projectile_deleted()

func _on_player_dead_zone_body_entered(body):
	var co = body as CollidableObject
	if co:
		_is_game_over = true

func _on_collidable_object_destroyed(co: CollidableObject):
	camera.shake_camera()

func on_projectile_launched(projectile: Projectile):
	camera.shake_camera()
	ui.add_balls_left(-1)

func _on_projectile_hit():
	score += 1
	ui.set_score(score)

func _on_projectile_deleted():
	round_projectile_count -= 1

func _game_over():
	print('game over')
	_reset()

func show_line():
	projectileLauncher.show_line()

func hide_line():
	projectileLauncher.hide_line()

func _spawn_collidable_objects(health: int):
	var spawned = collidableObjectSpawner.spawn(health)
	for co in spawned:
		co.death.connect(_on_collidable_object_destroyed)

func _move_all_collidable_objects():
	var tween = null
	for child in object_container.get_children():
		if child is CollidableObject:
			if !tween:
				tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			var start_pos = child.position
			var end_pos = start_pos + Vector2(0, -object_move_distance)
			tween.parallel().tween_property(child, "position", end_pos, object_move_duration)
	if tween == null:
		return
	await tween.finished
