class_name TextureButtonWithLabel
extends TextureButton

@export var text: String = "Button"
var label = null

func _find_label():
	for child in get_children():
		if child is Label:
			return child as Label
		if child is RichTextLabel:
			return child as RichTextLabel
	return null

func _get_configuration_warning() -> String:
	var label = _find_label()
	if not label:
		return "This node must have a Label or RichTextLabel child."
	return ""

func _ready() -> void:
	label = _find_label()