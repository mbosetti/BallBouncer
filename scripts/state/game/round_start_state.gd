extends "res://scripts/state/game/game_state.gd"

@export var health_muliplier_min = 1.3
@export var health_muliplier_max = 1.5

func enter():
	_start_round()

func _start_round():
	var round_health = (game.round + 1)
	game._spawn_collidable_objects(round_health * health_muliplier_min, round_health * health_muliplier_max)
	game.projectiles_count += 1
	game.round += 1
	game._has_shot = false
	game.ui.set_balls_left(game.projectiles_count)
	transition_deferred("round")
