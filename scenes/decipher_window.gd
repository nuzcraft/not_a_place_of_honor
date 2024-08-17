extends Window

signal check_pressed

const font_clear = preload("res://assets/cp437_20x20_2.png")
const font_sub = preload("res://assets/cp437_20x20_3.png")
const font_sub_un = preload("res://assets/cp437_20x20_4.png")

@export var num_letters: int = 26

@onready var decipher_grid: GridContainer = $Control/VBoxContainer/DecipherGrid
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var available_label: Label = $Control/VBoxContainer/AvailableLabel

var glyph_array = []
var replacing_array = []

var label_array = []
var lineedit_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var j = 0
	for child in decipher_grid.get_children():
		if child is VBoxContainer:
			if j >= num_letters:
				child.hide()
			else:
				for sub_child in child.get_children():
					if sub_child is Label :
						label_array.append(sub_child)
					elif sub_child is LineEdit:
						lineedit_array.append(sub_child)
			j += 1;
	v_box_container.reset_size()
	size.y = v_box_container.size.y + 4
	available_label.text = "lowercase %s-%s" % [char(97), char(97+num_letters-1)]
	
	var array = []
	var replaceable_array = []
	for i in num_letters:
		#array.append(97 + i)
		replaceable_array.append(97 + i)
	for i in 253:
		array.append(1 + i)
	
	for i in num_letters:
		var glyph = array.pick_random()
		glyph_array.append(array.pop_at(array.find(glyph)))
		var replacing = replaceable_array.pick_random()
		replacing_array.append(replaceable_array.pop_at(replaceable_array.find(replacing)))
		print("%d: %s is replacing %s (%s)" % [i, glyph, replacing, char(replacing)])
		var glyph_rect: Rect2 = font_clear.get_glyph_uv_rect(0, Vector2i(20, 0), glyph)
		font_sub.set_glyph_uv_rect(0, Vector2i(20, 0), replacing, glyph_rect)
		font_sub_un.set_glyph_uv_rect(0, Vector2i(20, 0), replacing, glyph_rect)
	
	for i in label_array.size():
		label_array[i].text = char(replacing_array[i])
		
func _process(delta: float) -> void:
	pass

func _on_check_button_pressed() -> void:
	for i in lineedit_array.size():
		if lineedit_array[i].text == char(replacing_array[i]):
			lineedit_array[i].editable = false
			var reset_rect: Rect2 = font_clear.get_glyph_uv_rect(0, Vector2i(20, 0), replacing_array[i])
			font_sub_un.set_glyph_uv_rect(0, Vector2i(20, 0), replacing_array[i], reset_rect)
	check_pressed.emit()
