extends Control

signal reset

export(String, MULTILINE) var text : String = ""

onready var text_view = $HBox/FinalText


func _process(_delta: float) -> void:
	text_view.text = text

func reset_pressed() -> void:
	emit_signal("reset")

func copy_pressed() -> void:
	OS.clipboard = text
