extends "res://scripts/state/game/game_state.gd"

func enter():
	_start_round()

func _start_round():
	var round_health = (game.round + 1) * 1.3
	game._spawn_collidable_objects(round_health)
	game.projectiles_count += 1
	game.round += 1
	game._has_shot = false
	game.ui.set_balls_left(game.projectiles_count)
	print("about to change state to round")
	transition_deferred("round")
