extends Control
tool

signal pressed(chosen)
signal first_pressed
signal second_pressed
signal third_pressed
signal forth_pressed
signal fifth_pressed

export var button1_text : String = ""
export var button2_text : String = ""
export var button3_text : String = ""
export var button4_text : String = ""
export var button5_text : String = ""

export var number_of_buttons : int = 2 setget _set_num_of_buttons

var button_string := "HContainer/VContainer/Button%s"
var border_string := "HContainer/VContainer/Horizontal Border%s"

func _process(_delta: float) -> void:
	get_node(button_string % 1).text = button1_text
	get_node(button_string % 2).text = button2_text
	get_node(button_string % 3).text = button3_text
	get_node(button_string % 4).text = button4_text
	get_node(button_string % 5).text = button5_text
	
	
func _emit_pressed(button_number):
	emit_signal("pressed", button_number)
	
	if button_number == 1:
		emit_signal("first_pressed")
	elif button_number == 2:
		emit_signal("second_pressed")
	elif button_number == 3:
		emit_signal("third_pressed")
	elif button_number == 4:
		emit_signal("forth_pressed")
	elif button_number == 5:
		emit_signal("ffith_pressed")


func _set_num_of_buttons(new_value):
	#hide all of the buttons
	for i in range(1, 6):
		get_node(border_string % i).visible = false
		get_node(button_string % i).visible = false
	
	#show the correct number
	for i in range(1, new_value + 1):
		get_node(border_string % i).visible = true
		get_node(button_string % i).visible = true
		
