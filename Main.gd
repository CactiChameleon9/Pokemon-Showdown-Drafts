extends Control


export(String, MULTILINE) var pokemon_text : String


onready var pokemon_container : Control = $HBox/PokemonContainer
onready var button_selection : Control = $HBox/ButtonSelection


signal has_poped_values_true
signal has_chosen_pkmn_true
signal has_reset_true

remote var has_poped_values : bool = false
remote var has_chosen_pkmn : bool = false
remote var has_reset : bool = false
var pkmn_data = []
var selected_pkmn = []

var is_offline : bool = false

func _ready() -> void:
	randomize()
	
	yield(user_networking_choice(), "completed")
	
	$SettingsMenu.visible_button = false
	#select some custom text if valid
	var settings_pokemon_text = $SettingsMenu.get_pokemon_text()
	if "-" in settings_pokemon_text: #if a move is detected
		pokemon_text = settings_pokemon_text
	
	while true:
		#split up the data into each pokemon
		pkmn_data = process_pokemon_text(pokemon_text)
		
		yield(select_pkmn(), "completed")
		
		yield(finished_ui(), "completed")


func _process(_delta: float) -> void:
	
	if is_offline: # disable all networking waits if offline
		has_poped_values = true
		has_chosen_pkmn = true
		has_reset = true
	
	if has_poped_values or get_tree().is_network_server():
		emit_signal("has_poped_values_true")
	
	if has_chosen_pkmn:
		emit_signal("has_chosen_pkmn_true")
	
	if has_reset:
		emit_signal("has_reset_true")


func finished_ui():
	OS.clipboard = pkmn_array_to_text(selected_pkmn) #copy pokepaste to clipboard
	
	#hide the pokemon view
	$HBox.visible = false
	
	#show the final text
	$FinalScreen.text = pkmn_array_to_text(selected_pkmn)
	$FinalScreen.visible = true
	
	yield($FinalScreen, "reset") #reset button pressed
	rset("has_reset", true)
	
	yield(self, "has_reset_true") #wait until both have reset
	#hide the final text
	$FinalScreen.visible = false
	
	#show the pokemon view
	$HBox.visible = true
	
	#reset the sidebar
	$SelectedSidebar.reset()
	
	has_reset = false


func select_pkmn():
	button_selection.number_of_buttons = 2 
	selected_pkmn = [] #reset the selected pkmn
	
	while len(selected_pkmn) < 6:
		
		#yield until variable change, or carry on if server
		yield(self, "has_poped_values_true")
		
		var draft_number = randi() % len(pkmn_data) # select random pkmn (and remove it from list)
		var draft1 : Pokemon = pkmn_data.pop_at(draft_number)
		rpc("pop_pkmn_data", draft_number) # remove pkmn from remote list
		
		draft_number = randi() % len(pkmn_data)
		var draft2 : Pokemon = pkmn_data.pop_at(draft_number)
		rpc("pop_pkmn_data", draft_number)
		
		yield(get_tree().create_timer(0.1), "timeout")
		rset("has_poped_values", true) # allow the client to select its pokemon
		
		#remove existing pokemon info UI
		if len(pokemon_container.get_children()) != 0:
			pokemon_container.remove_child(pokemon_container.get_children()[0])
			pokemon_container.remove_child(pokemon_container.get_children()[0])
		
		#add new pokemon info UI
		pokemon_container.add_child(draft1)
		pokemon_container.add_child(draft2)
		
		draft1.load_pictures()
		draft2.load_pictures()
		
		button_selection.button1_text = "Choose " + draft1.a_name
		button_selection.button2_text = "Choose " + draft2.a_name
		var choice = yield(button_selection, "pressed")
		
		yield(get_tree().create_timer(0.1), "timeout")
		rset("has_chosen_pkmn", true)
		
		yield(self, "has_chosen_pkmn_true") #wait until other has chosen
		
		if choice == 1:
			selected_pkmn.append(draft1)
			$SelectedSidebar.set_pokemon(draft1.a_name, draft2.a_name)
			rpc("set_them_chosen", draft1.export_text(), draft2.export_text())
		elif choice == 2:
			selected_pkmn.append(draft2)
			$SelectedSidebar.set_pokemon(draft2.a_name, draft1.a_name)
			rpc("set_them_chosen", draft2.export_text(), draft1.export_text())
		
		yield(get_tree().create_timer(0.1), "timeout")
		#reset the waiting
		has_poped_values = false
		has_chosen_pkmn = false


func pkmn_array_to_text(pkmn_array):
	var text = ""
	
	for pkmn in pkmn_array:
		text += pkmn.export_text()
		text += "\n"
		
	return text


func process_pokemon_text(text):
	var text_array = text.split("\n\n")
	var array = []
	
	#make a new array with the pokemon class
	for i in range (0, len(text_array)):
		var tmp = preload("res://Pokemon.tscn").instance()
		tmp.import_text(text_array[i])
		array.append(tmp)
	
	return array


remote func pop_pkmn_data(num : int):
	pkmn_data.pop_at(num)


remote func set_them_chosen(their_pkmn_text, your_pkmn_text):
	#turn the text(remote code execution possible with object) back into pkmn
	var their_pkmn = load("res://Pokemon.tscn").instance()
	var your_pkmn = load("res://Pokemon.tscn").instance()
	their_pkmn.import_text(their_pkmn_text)
	your_pkmn.import_text(your_pkmn_text)

	selected_pkmn.append(your_pkmn)
	$SelectedSidebar.set_pokemon(your_pkmn.a_name, their_pkmn.a_name)


func networking_stuff(is_client : bool, server_address = ""):
	var peer = NetworkedMultiplayerENet.new()
	
	#enable client/server
	if is_client:
		print("client")
		peer.create_client(server_address, 28012) #Address, Port
	else:
		print("server")
		peer.create_server(28012, 2) #Port, MaxPlayers
	
	get_tree().network_peer = peer
	print("initialised")
	
	#wait until connected
	if is_client:
		yield(get_tree(), "connected_to_server")
	else:
		yield(get_tree(), "network_peer_connected")
	
	print("connected")
	
	#disable new connections
	get_tree().set_refuse_new_network_connections(false)


func user_networking_choice():
	button_selection.number_of_buttons = 3
	
	button_selection.button1_text = "Client"
	button_selection.button2_text = "Offline"
	button_selection.button3_text = "Server"
	var choice = yield(button_selection, "pressed")
	
	if choice == 2: #offline
		is_offline = true
		return
	
	var is_client : bool = true if choice == 1 else false
	
	var server_address
	if is_client: #an ip address needs to be entered
		button_selection.button2_text = "" #hide other button
		
		$AddressDialog.visible = true #make the dialog visible
		
		yield($AddressDialog, "enter_pressed") #wait until input finished
		server_address = $AddressDialog.text #get the text
		
		$AddressDialog.visible = false #hide the dialog
		
	else:
		#show server address in 1st button
		var ip_address : String = "" #TODO fix for actual ip if virt0
		
		for address in IP.get_local_addresses():
			if address.split('.').size() == 4:
				if "192" in address or "10" in address:
					ip_address=address
		
		button_selection.button1_text = ip_address
	
	yield(networking_stuff(is_client, server_address), "completed")
