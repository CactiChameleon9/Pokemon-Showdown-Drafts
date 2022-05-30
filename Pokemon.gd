class_name Pokemon
extends Control

var a_name = ""
var item = ""
var ability = ""
var level = ""
var nature = ""
var ev_hp = 00; var ev_atk = 00; var ev_spa = 00; var ev_spd = 00; var ev_def = 00; var ev_spe = 00 #up to 252
var iv_hp = 31; var iv_atk = 31; var iv_spa = 31; var iv_spd = 31; var iv_def = 31; var iv_spe = 31 #up to 31, default 31
var moves = ["","","",""]

func _ready() -> void:
	pass
	#update_ui()


func load_pictures():
	var pokemon_image = $HBContainer/PokemonImage
	var picture_location = "res://assets/Pokemon/%s.png"
	
	var texture = load(picture_location % Global.PokemonDict[a_name.to_lower()])

	pokemon_image.texture = texture


func update_ui():
	var a_name_node = $NameLabel
	var item_node = $HBContainer/PokemonDetails/HContainer/VContainer/AbilityItemPanel/VContainer/ItemContainer/Item
	var ability_node = $HBContainer/PokemonDetails/HContainer/VContainer/AbilityItemPanel/VContainer/AbilityContainer/Ability
	var nature_plus_node = $HBContainer/PokemonDetails/HContainer/VContainer/StatsPanel/VContainer/NatureContainer/NaturePlus
	var nature_minus_node = $HBContainer/PokemonDetails/HContainer/VContainer/StatsPanel/VContainer/NatureContainer/NatureMinus
	var ev_node = $HBContainer/PokemonDetails/HContainer/VContainer/StatsPanel/VContainer/EVContainer/EVs
	var iv_node = $HBContainer/PokemonDetails/HContainer/VContainer/StatsPanel/VContainer/IVContainer/IVs
	var move_node_str = "HBContainer/PokemonDetails/HContainer/VContainer/MovesPanel/HContainer/MoveContainer%s/Move%s"
	
	a_name_node.text = a_name
	item_node.text = item
	ability_node.text = ability
	
	for i in len(Global.Natures):
		if Global.Natures[i][0].capitalize() == nature.capitalize():
			nature_plus_node.text = "+" + Global.Natures[i][1]
			nature_minus_node.text = "-" + Global.Natures[i][2]
	
	ev_node.text = "" #reset the ev text box
	var evs_added : int = 0
	for ev in [[ev_hp, "HP"], [ev_atk, "Atk"], [ev_def, "Def"],
		 [ev_spa, "SpA"], [ev_spd, "Spd"], [ev_spe, "Spe"]]:
		
		if str(ev[0]) == "0":
			continue
		
		evs_added +=1
		
		ev_node.text += str(ev[0]) + " " + ev[1] #add value space name
		
		if evs_added % 2 == 1: #1st and 3rd and 5th value added
			ev_node.text += " / "
		else: #2nd and 4th and 6th value added
			ev_node.text += "\n"
	
	iv_node.text = "" #reset the iv text box
	var ivs_added : int = 0
	for iv in [[iv_hp, "HP"], [iv_atk, "Atk"], [iv_def, "Def"],
		 [iv_spa, "SpA"], [iv_spd, "Spd"], [iv_spe, "Spe"]]:
		
		if str(iv[0]) == "31":
			continue
		
		ivs_added +=1
		
		iv_node.text += str(iv[0]) + " " + iv[1] #add value space name
		
		if ivs_added % 2 == 1: #1st and 3rd and 5th value added
			iv_node.text += " / "
		else: #2nd and 4th and 6th value added
			iv_node.text += "\n"
	
	
	#remove leading separators 
	ev_node.text = ev_node.text.trim_suffix(" / ")
	ev_node.text = ev_node.text.trim_suffix("\n")
	
	iv_node.text = iv_node.text.trim_suffix(" / ")
	iv_node.text = iv_node.text.trim_suffix("\n")
	
	
	for i in range(0, 4):
		get_node(move_node_str % [i + 1, i + 1]).text = moves[i]

func import_text(text):
	var text_array = text.split("\n") #split the text up into different lines
	
	var a_name_pos = array_pos(text_array, "@") if array_pos(text_array, "@") else 0 #not always item
	var item_pos = array_pos(text_array, "@")
	var ability_pos = array_pos(text_array, "Ability: ")
	var level_pos = array_pos(text_array, "Level: ")
	var nature_pos = array_pos(text_array, " Nature")
	var ev_pos = array_pos(text_array, "EVs: ")
	var iv_pos = array_pos(text_array, "IVs: ")
	
	
	a_name = a_name   if a_name_pos == null else text_array[a_name_pos].split(" @ ")[0]			#Grumpig @ Aguav Berry
	a_name = a_name.trim_suffix(" (F)").trim_suffix(" (M)")
	a_name = a_name.trim_suffix(" ").trim_suffix(" ").trim_suffix(" ").trim_suffix(" ")
	item = item       if item_pos == null else text_array[item_pos].split(" @ ")[1]
	ability = ability if not ability_pos else text_array[ability_pos].replace("Ability: ", "")	#Ability: Gluttony
	level = level if not level_pos else text_array[level_pos].replace("Level: ", "")			#Level: 100
	nature = nature   if not nature_pos else text_array[nature_pos].replace(" Nature", "")		#Quiet Nature
	nature = nature.replace(" ", "")
	
	ev_hp  = ev_hp  if not ev_pos else return_EV_IV(text_array[ev_pos],  ("HP"))				#EVs: 252 HP / 4 func / 252 SpA
	ev_atk = ev_atk if not ev_pos else return_EV_IV(text_array[ev_pos], ("Atk"))
	ev_def = ev_def if not ev_pos else return_EV_IV(text_array[ev_pos], ("Def"))
	ev_spa = ev_spa if not ev_pos else return_EV_IV(text_array[ev_pos], ("SpA"))
	ev_spd = ev_spd if not ev_pos else return_EV_IV(text_array[ev_pos], ("SpD"))
	ev_spe = ev_spe if not ev_pos else return_EV_IV(text_array[ev_pos], ("Spe"))
	
	iv_hp  = iv_hp  if not iv_pos else return_EV_IV(text_array[iv_pos],  ("HP"), 31)			#IVs: 0 Atk / 0 Spe
	iv_atk = iv_atk if not iv_pos else return_EV_IV(text_array[iv_pos], ("Atk"), 31)
	iv_def = iv_def if not iv_pos else return_EV_IV(text_array[iv_pos], ("Def"), 31)
	iv_spa = iv_spa if not iv_pos else return_EV_IV(text_array[iv_pos], ("SpA"), 31)
	iv_spd = iv_spd if not iv_pos else return_EV_IV(text_array[iv_pos], ("SpD"), 31)
	iv_spe = iv_spe if not iv_pos else return_EV_IV(text_array[iv_pos], ("Spe"), 31)
	
	var move_num = 0																			#- Trick Room
	for i in range(0, len(text_array)):															#- Psychic
		if "- " in text_array[i]:																#- Shadow Ball
			moves[move_num] = text_array[i].replace("- ", "")									#- Calm Mind
			move_num += 1
	
	update_ui()


func export_text():
	var text = ""
	
	if item:
		text += "\n" + a_name + " @ " + item
	else:
		text += "\n" + a_name
	text += "\n" + "Ability: " + ability
	text += "\n" + "Level: " + level
	text += "\n" + nature + " Nature"
	text += "\n" + "EVs: " + str(ev_hp) + " HP / " + str(ev_atk) + " Atk / " + str(ev_def) + " Def / " + str(ev_spa) + " SpA / " +  str(ev_spd) + " SpD / " + str(ev_spe) + " Spe"
	text += "\n" + "IVs: " + str(iv_hp) + " HP / " + str(iv_atk) + " Atk / " + str(iv_def) + " Def / " + str(iv_spa) + " SpA / " +  str(iv_spd) + " SpD / " + str(iv_spe) + " Spe"
	for i in moves:
		text += "\n" + "- " + i
	
	return text

func array_pos(array, value):
#this function returns the first index of an array containing a given string
	for i in range(0, len(array)):
		if value in array[i]:
			return i


func return_EV_IV(ev_iv_data, value, default_value = 0):
#this function processes the ev/iv data and outputs the selected one/ a default if not found
	var ev_iv = ev_iv_data.replace("EVs: ", "").replace("IVs: ", "").split(" / ")
	var tmp = []
	for i in range(0, len(ev_iv)):
		tmp.append(ev_iv[i].split(" ")[0])
		tmp.append(ev_iv[i].split(" ")[1])
	ev_iv = tmp
	
	var ev_iv_index = ev_iv.find(value) - 1
	
	var final_value = default_value if ev_iv_index == -2 else ev_iv[ev_iv.find(value) - 1]

	return final_value
