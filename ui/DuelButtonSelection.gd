extends Control
tool

signal pressed(chosen)
signal first_pressed
signal second_pressed

export var button1_text : String = ""
export var button2_text : String = ""

onready var button1 = $HContainer/VContainer/Button1
onready var button2 = $HContainer/VContainer/Button2

func _process(_delta: float) -> void:
	button1.text = button1_text
	button2.text = button2_text
	
func _emit_pressed(button_number):
	emit_signal("pressed", button_number)
	
	if button_number == 1:
		emit_signal("first_pressed")
	elif button_number == 2:
		emit_signal("second_pressed")
