extends "res://scripts/state/game/game_state.gd"

var projectiles_launched = false

func enter():
	await game._move_all_collidable_objects()
	if game._is_game_over:
		# TODO: show game over screen
		transition_deferred("game_over")
	transition_deferred("round_start")