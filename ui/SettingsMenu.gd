extends CanvasLayer


var visible : bool = false
var visible_button : bool = true

var selected_text : int = 1

var pokemon_text_location := "SettingsMenu/PanelContainer/HContainer/ScrollContainer/VContainer/PanelContainer/VContainer/TextEdit%s"
var checkbox_location := "SettingsMenu/PanelContainer/HContainer/ScrollContainer/VContainer/PanelContainer/VContainer/HBoxContainer%s/CheckBox"


func _ready() -> void:
	#check the currently selected text
	get_node(checkbox_location % selected_text).pressed = true
	
	_load_data()
	
#	#run the process once on ready to prevent errors with null/empty values
#	_process(0)


func _process(_delta):
	#show and hide the nodes based of visible bools
	$SettingsMenu/PanelContainer.visible = visible
	$SettingsMenu/SettingsButton.visible = visible_button


func get_pokemon_text() -> String:
	return get_node(pokemon_text_location % selected_text).text


func _save_data(hide_too : bool = false):
	var config = ConfigFile.new()
	
	#store some values
	config.set_value("pokemonpool", "slot1", get_node(pokemon_text_location % 1).text)
	config.set_value("pokemonpool", "slot2", get_node(pokemon_text_location % 2).text)
	config.set_value("pokemonpool", "slot3", get_node(pokemon_text_location % 3).text)
	
	config.set_value("pokemonpool", "selected", selected_text)
	
	#save it to a file (overwrite if already exists)
	config.save("user://settings.cfg")
	
	if hide_too:
		visible = false


func _load_data():
	var config = ConfigFile.new()
	
	if config.load("user://settings.cfg") != OK:
		return
	
	for num in range(1, 4):
		get_node(pokemon_text_location % num).text = config.get_value(
			"pokemonpool", "slot%s" % num, "")
	
	selected_text = config.get_value("pokemonpool", "selected", 1)
	get_node(checkbox_location % selected_text).pressed = true


func _input(event):
	if visible && event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			
			#hide the setttings
			visible = false
			
			_save_data()


func _on_CheckBox_toggled(button_pressed : bool, number_toggled : int) -> void:	
	#don't do anything for unpressing buttons
	if button_pressed == false:
		return
	
	#uncheck all of the other checkboxes
	for i in range(1, 4):
		#skip disabling current button
		if i == number_toggled:
			continue
		
		get_node(checkbox_location % i).pressed = false
	
	selected_text = number_toggled


func _on_SettingsButton_pressed() -> void:
	#show settings
	visible = true
