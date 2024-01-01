class_name AudioClipParams
extends Resource

@export var sound_path: String
@export var expiration: float = -1
@export var priority: int = 100
@export var pitch: float = 1.0
@export var pitch_min: float = 1.0
@export var pitch_max: float = 1.0

func duplicate_random_pitch() -> AudioClipParams:
	var new_params = duplicate()
	new_params.pitch = randf_range(pitch_min, pitch_max)
	return new_params