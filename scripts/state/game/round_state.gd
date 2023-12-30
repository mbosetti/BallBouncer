extends "res://scripts/state/game/game_state.gd"

func enter():
	game._has_shot = false

func exit():
	game.hide_line()

func update(delta):
	if Input.is_action_pressed("click") && !game._has_shot:
		game.show_line()
	if Input.is_action_just_released("click"):
		game._launch_projectiles()
	if game._has_shot && game.round_projectile_count == 0:
		transition_deferred("round_end")
