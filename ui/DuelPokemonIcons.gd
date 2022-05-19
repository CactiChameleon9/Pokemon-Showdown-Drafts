extends Control

export var image_location = "res://assets/PokemonMini/%s.png"

onready var them_image = $AspectRatioContainer/Circle/ThemImage
onready var your_image = $AspectRatioContainer/Circle/YourImage


func set_them_image(a_name : String):
	_set_image(a_name, true)

func set_your_image(a_name : String):
	_set_image(a_name, false)

func _set_image(a_name, is_them : bool):
	var texture = load(image_location % Global.PokemonDict[a_name.to_lower()])
	
	if is_them:
		them_image.texture = texture
	if not is_them:
		your_image.texture = texture 

func reset():
	them_image.texture = null
	your_image.texture = null
