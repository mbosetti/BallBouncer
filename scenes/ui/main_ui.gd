class_name UI

extends CanvasLayer

@export var score_label: Label
@export var balls_left_label: Label

var _score: int = 0
var _balls_left: int = 0

func _ready() -> void:
	_update_score_label()

# Score
func set_score(score: int) -> void:
	_score = score
	_update_score_label()

func add_score(score: int) -> void:
	_score += score
	_update_score_label()

func _update_score_label() -> void:
	score_label.text = "Score: " + str(_score)

# Balls Left
func set_balls_left(balls_left: int) -> void:
	_balls_left = balls_left
	_update_balls_left_label()

func add_balls_left(balls_left: int) -> void:
	_balls_left += balls_left
	_update_balls_left_label()

func _update_balls_left_label() -> void:
	balls_left_label.text = "Balls Left: " + str(_balls_left)
