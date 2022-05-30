extends Button

signal delete_pool(pool_name)
signal edit_pool(pool_name)

var pokemon_text : String = "" setget _set_pokemon_text, _get_pokemon_text
var editable : bool = false setget _set_editable, _get_editable


onready var _text_edit = $MarginContainer/VContainer/TextEdit
onready var _label = $MarginContainer/VContainer/Label1


func _ready() -> void:
	_label = name


func _set_pokemon_text(value : String):
	_text_edit.text = value

func _get_pokemon_text() -> String:
	return _text_edit.text


func _set_editable(value : bool):
	if value == true:
		_text_edit.mouse_filter = MOUSE_FILTER_STOP
		_text_edit.mouse_default_cursor_shape = Control.CURSOR_IBEAM
		disabled = true
	else:
		_text_edit.mouse_filter = MOUSE_FILTER_IGNORE
		_text_edit.mouse_default_cursor_shape = Control.CURSOR_ARROW
		disabled = false

func _get_editable() -> bool:
	return true if _text_edit.mouse_filter == MOUSE_FILTER_STOP else false


func _on_DeleteButton_pressed() -> void:
	emit_signal("delete_pool", name)
	queue_free()

func _on_EditButton_pressed() -> void:
	#pass mouse mode means pressing the button also presses the main one
	pressed = not pressed
	emit_signal("edit_pool", name)
