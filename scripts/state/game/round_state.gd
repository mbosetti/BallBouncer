extends "res://scripts/state/game/game_state.gd"

var projectiles_launched = false

func enter():
	game.projectileLauncher.show_line()
	projectiles_launched = false
	game._has_shot = false

func exit():
	game.projectileLauncher.hide_line()

func update(delta):
	if Input.is_action_just_released("click"):
		_launch_projectiles()
		projectiles_launched = true
	if projectiles_launched && game.round_projectile_count == 0:
		transition_deferred("round_end")

func _launch_projectiles():
	if !game._has_shot:
		game._has_shot = true
		game.projectileLauncher.hide_line()
		game.round_projectile_count = game.projectiles_count
		var mouse_pos = game.get_launcher_target_position()
		var projectiles = await game.projectileLauncher.launch_multiple(ProjectileLauncher.Params.new(mouse_pos, game.object_container, game.projectiles_count, game._on_projectile_hit))
