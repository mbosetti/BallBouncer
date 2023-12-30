class_name DefaultCamera

extends Camera2D

@onready var shake = $Shake

func shake_camera():
	shake.shake()