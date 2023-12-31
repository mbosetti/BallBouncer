extends "res://scripts/state/game/game_state.gd"

var projectiles_launched = false

func enter():
	game.gameOverScreen.visible = true
	game.set_score(game.score)
	game.save_game()