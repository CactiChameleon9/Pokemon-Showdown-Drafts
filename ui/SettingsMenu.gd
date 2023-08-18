extends CanvasLayer


var self_visible : bool = false
var visible_button : bool = true

var pool_preview_location := "SettingsMenu/PanelContainer/HContainer/ScrollContainer/VContainer/PanelContainer/VContainer/HBoxContainer%s/CheckBox"
onready var auto_grid_container := $SettingsMenu/PanelContainer/HContainer/VContainer/AutoGridContainer


func _ready() -> void:
	_load_data()


func _process(_delta):
	#show and hide the nodes based of visible bools
	$SettingsMenu/PanelContainer.visible = self_visible
	$SettingsMenu/SettingsButton.visible = visible_button


func get_pokemon_text() -> String:
	var total_pokemon_text : String = ""
	
	#iterate through all of the pools and use the selected ones for the pokemon text
	for pool in auto_grid_container.grid_container.get_children():
		#disclude any non-pool
		if not "PoolPreview" in pool.name:
			continue
		
		#disclude any not selected
		if not pool.pressed:
			continue
		
		if auto_grid_container.get_node_from_grid(pool.name):
			total_pokemon_text += auto_grid_container.get_node_from_grid(pool.name).pokemon_text + "\n"
	
	return total_pokemon_text

func _save_data(hide_after : bool = false):
	var config = ConfigFile.new()
	
	#store some values
	for pool in auto_grid_container.grid_container.get_children():
		#disclude any non-pool nodes
		if not "Pool" in pool.name:
			continue
		
		#store the pools and if they are selected in seperate sections
		config.set_value("pokemonpools", pool.name, pool.pokemon_text)
		config.set_value("selectedpools", pool.name, pool.pressed)
	
	#save it to a file (overwrite if already exists)
	config.save("user://settings.cfg")
	
	if hide_after:
		self_visible = false


func _load_data():
	var config = ConfigFile.new()
	
	if config.load("user://settings.cfg") != OK:
		return
	
	#return if there are no pools stored
	if not config.has_section("pokemonpools"):
		return
	
	#add all of the pools to the grid container
	for pool_name in config.get_section_keys("pokemonpools"):
		_add_pokemon_pool(pool_name, config.get_value("pokemonpools", pool_name, ""))
	
	var selected_pools = []
	#fill the selected_pools array 
	for pool_name in config.get_section_keys("selectedpools"):
		if config.get_value("selectedpools", pool_name):
			selected_pools.append(pool_name)
	
	#move the children to the grid, because this runs before _process
	auto_grid_container._move_children_to_grid()
	
	#press(select) all of the selected pools
	for pool in selected_pools:
		if auto_grid_container.get_node_from_grid(pool):
			auto_grid_container.get_node_from_grid(pool).pressed = true


func _on_SettingsButton_pressed():
	#show settings
	self_visible = true


func _add_pokemon_pool(pool_name : String = "", text : String = ""):
	var pool_preview = preload("res://ui/PoolPreview.tscn")
	
	if pool_name == "":
		pool_name = "Pool %05d" % int(rand_range(0, 99999))
	
	var pool = pool_preview.instance()
	
	pool.connect("edit_pool", self, "_edit_pool")
	
	auto_grid_container.add_child(pool)
	
	pool.pool_name = pool_name
	pool.pokemon_text = text
	
	auto_grid_container._move_children_to_grid()
	
	if auto_grid_container.grid_container.has_node("PlusButton"):
		auto_grid_container.grid_container.move_child(
			auto_grid_container.grid_container.get_node("PlusButton"),
			auto_grid_container.grid_container.get_node("PlusButton").get_index() + 1)


func _edit_pool(pool_name):
	if pool_name == "" or pool_name == null:
		return
	
	if auto_grid_container.get_node_from_grid(pool_name):
		#this gets the pool node, and then moves it to the scroll container (to fullscreen)
		var pool = auto_grid_container.grid_container.get_node(pool_name)
		auto_grid_container.grid_container.remove_child(pool)
		auto_grid_container.get_node("Scroll").add_child(pool)
		pool.editable = true
		
	elif auto_grid_container.get_node("Scroll").has_node(pool_name):
		#this gets the pool node, and then moves it to the scroll container (to fullscreen)
		var pool = auto_grid_container.get_node("Scroll").get_node(pool_name)
		auto_grid_container.get_node("Scroll").remove_child(pool)
		auto_grid_container.grid_container.add_child(pool)
		auto_grid_container.grid_container.move_child(pool, 0)
		#for some reason this is needed to prevent the button being stuck in hover mode
		yield(get_tree().create_timer(0.01), "timeout")
		pool.editable = false
	
