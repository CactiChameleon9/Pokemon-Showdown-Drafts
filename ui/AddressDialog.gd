extends CanvasLayer


onready var line_edit : LineEdit = $AddressDialog/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/AddressInput/LineEdit
onready var line_hint : LineEdit = $AddressDialog/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/AddressInput/LineHint

signal enter_pressed


export var text : String = ""
export var self_visible : bool = false


func _process(_delta: float) -> void:
	
	if len(line_edit.text) > 0:
		line_hint.visible = false
	else:
		line_hint.visible = true
	
	text = line_edit.text
	$AddressDialog.visible = self_visible

func _input(event):
	if self_visible && event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			emit_signal("enter_pressed")
