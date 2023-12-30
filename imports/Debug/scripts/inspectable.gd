class_name Inspectable

extends Node

@onready var ui_debug: UIDebug = $UIDebug

var parent = null

func _ready():
	parent = get_node('..')
	ui_debug.hideDebugPanel()
		
func _process(delta):
	ui_debug.setDebugText(str(parent.transform))

func _on_area_2d_mouse_entered():
	ui_debug.showDebugPanel()

func _on_area_2d_mouse_exited():
	ui_debug.hideDebugPanel()
