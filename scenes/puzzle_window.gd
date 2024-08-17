extends Window
signal correct

@onready var final_label: Label = $Control/VBoxContainer/FinalLabel
@onready var final_line_edit: LineEdit = $Control/VBoxContainer/FinalLineEdit

@export var passcode: String

func _ready() -> void:
	final_label.text = passcode

func _on_final_check_button_pressed() -> void:
	if final_label.text == final_line_edit.text:
		correct.emit(passcode)
