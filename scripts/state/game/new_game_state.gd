extends "res://scripts/state/game/game_state.gd"

var projectiles_launched = false

func enter():
	game._reset()
	transition_deferred("round_start")