class_name Shake

extends Node2D

@export var target: Node2D

var _shake_tween = null

func _ready():
	if !target: target = get_parent()

func shake():
	if !_shake_tween:
		var start_pos = target.position
		var end_pos = start_pos + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		_shake_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		_shake_tween.tween_property(target, "position", end_pos, 0.1)
		await _shake_tween.finished
		target.position = start_pos
		_shake_tween = null