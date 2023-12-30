extends Control

@onready var high_score_label: Label = $Panel/HighScoreLabel
@onready var score_label: Label = $Panel/ScoreLabel

func _on_reset_button_pressed():
	get_tree().reload_current_scene()

func set_score(value: int):
	score_label.text = "Score: " + str(value)

func set_high_score(value: int):
	high_score_label.text = "High Score: " + str(value)