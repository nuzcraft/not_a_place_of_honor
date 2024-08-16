extends Node2D

const f_clean: FontFile = preload("res://assets/cp437_20x20_2.png")
const f: FontFile = preload("res://assets/cp437_20x20_3.png")

var glyph_array = []
var replacing_array = []

var label_array = []
var lineedit_array = []

func _ready() -> void:
	var array = []
	var replaceable_array = []
	for i in 26:
		#array.append(97 + i)
		replaceable_array.append(97 + i)
	for i in 253:
		array.append(1 + i)
	
	for i in 26:
		var glyph = array.pick_random()
		glyph_array.append(array.pop_at(array.find(glyph)))
		var replacing = replaceable_array.pick_random()
		replacing_array.append(replaceable_array.pop_at(replaceable_array.find(replacing)))
		print("%d: %s is replacing %s (%s)" % [i, glyph, replacing, char(replacing)])
		var glyph_rect: Rect2 = f_clean.get_glyph_uv_rect(0, Vector2i(20, 0), glyph)
		f.set_glyph_uv_rect(0, Vector2i(20, 0), replacing, glyph_rect)

	print(char(glyph_array[0]))
	print(char(replacing_array[0]))
	#$VBoxContainer/GridContainer/VBoxContainer/Label.text = char(replacing_array[0])
	for vbox in $VBoxContainer/GridContainer.get_children():
		if vbox is VBoxContainer:
			for ch in vbox.get_children():
				if ch is Label:
					label_array.append(ch)
				elif ch is LineEdit:
					lineedit_array.append(ch)
					
	
	for i in label_array.size():
		label_array[i].text = char(replacing_array[i])

func _process(delta: float) -> void:
	pass


func _on_check_button_pressed() -> void:
	for i in lineedit_array.size():
		if lineedit_array[i].text == char(replacing_array[i]):
			lineedit_array[i].editable = false
			var reset_rect: Rect2 = f_clean.get_glyph_uv_rect(0, Vector2i(20, 0), replacing_array[i])
			f.set_glyph_uv_rect(0, Vector2i(20, 0), replacing_array[i], reset_rect)
	$VBoxContainer/Label2.add_theme_font_override("font", f)
