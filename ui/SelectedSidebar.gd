extends Control

var duel_icons_string := "Margin/VBox/DuelIcons%s"

var current_number = 0


func set_pokemon(your_name, them_name):
	current_number += 1
	var duel_icon = get_node(duel_icons_string % current_number)
	duel_icon.set_your_image(your_name)
	duel_icon.set_them_image(them_name)
	

func reset():
	for i in $Margin/VBox.get_children():
		if "DuelIcons" in i.name:
			i.reset()
