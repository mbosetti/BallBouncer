class_name UIDebug
extends Control

@onready var DebugPanel: CanvasGroup = $DebugPanel
@onready var Background: ColorRect = $DebugPanel/Background
@onready var Text: RichTextLabel = $DebugPanel/Text

func showDebugPanel():
	DebugPanel.show()

func hideDebugPanel():
	DebugPanel.hide()

func setDebugText(text: String):
	Text.bbcode_text = text

func clearDebugText():
	Text.bbcode_text = ""

func addDebugText(text: String):
	Text.bbcode_text += text

func setDebugTextColor(color: Color):
	Text.bbcode_color = color

func setDebugTextSize(size: int):
	Text.bbcode_size = size

func setDebugBackgroundColor(color: Color):
	Background.color = color
