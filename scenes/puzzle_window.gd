extends Window
signal correct

@onready var final_label: Label = $Control/VBoxContainer/FinalLabel
@onready var final_line_edit: LineEdit = $Control/VBoxContainer/FinalLineEdit

@export var passcode: String

func _ready() -> void:
	final_label.text = passcode
	print(passcode)

func _on_final_check_button_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_3)
	if final_label.text == final_line_edit.text:
		#SoundPlayer.play_sound(SoundPlayer.JINGLES_SAX_02)
		correct.emit(passcode)
		
func set_passcode(code: String) -> void:
	passcode = code
	final_label.text = code
	final_line_edit.text = ""
	print(code)


func _on_final_check_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_1)
