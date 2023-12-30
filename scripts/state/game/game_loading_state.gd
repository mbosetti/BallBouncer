extends "res://scripts/state/game/game_state.gd"

func enter():
	if game.has_loaded.is_connected(has_loaded):
		has_loaded()
	else:
		await game.has_loaded.connect(has_loaded)

func has_loaded():
	transition_deferred("new_game")
