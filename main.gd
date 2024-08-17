extends Node2D

const font_clear = preload("res://assets/cp437_20x20_2.png")
const font_sub = preload("res://assets/cp437_20x20_3.png")
const font_sub_un = preload("res://assets/cp437_20x20_4.png")
const UNSCRAMBLE_THEME = preload("res://unscramble_theme.tres")

const DECIPHER_WINDOW = preload("res://scenes/decipher_window.tscn")
const PUZZLE_WINDOW = preload("res://scenes/puzzle_window.tscn")
const IMAGE_WINDOW = preload("res://scenes/image_window.tscn")

func _ready() -> void:
	# change the label fonts to black
	override_font_color(self, Color.BLACK)
	
	var decipher_window = DECIPHER_WINDOW.instantiate()
	decipher_window.num_letters = 5
	override_font_color(decipher_window, Color.BLACK)
	add_child(decipher_window)
	decipher_window.check_pressed.connect(_on_decipher_window_check_pressed)
	
	var puzzle_window = PUZZLE_WINDOW.instantiate()
	puzzle_window.passcode = "cabby"
	override_font_color(puzzle_window, Color.BLACK)
	add_child(puzzle_window)
	puzzle_window.correct.connect(_on_correct_solve)
	
	var image_window = IMAGE_WINDOW.instantiate()
	image_window.first_texture = preload("res://assets/classroom.webp")
	image_window.first_label = "alphabet on a classroom wall"
	override_font_color(image_window, Color.BLACK)
	add_child(image_window)
	image_window.add_texture_and_label(preload("res://assets/spike_field.webp"), "spike fields of yore")

func _process(delta: float) -> void:
	pass
	
func _on_correct_solve(pw: String) -> void:
	$Popup.show()
	$Popup/VBoxContainer/Label2.text = "the word was %s" % pw

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_decipher_window_check_pressed() -> void:
	for i in get_all_children(self):
		if i is Label and i.theme == UNSCRAMBLE_THEME:
			i.add_theme_font_override("font", font_sub_un)
	
func get_all_children(node) -> Array:
	var nodes: Array = []
	for i in node.get_children():
		if i.get_child_count() > 0:
			nodes.append(i)
			nodes.append_array(get_all_children(i))
		else:
			nodes.append(i)
	return nodes
	
func override_font_color(node, color: Color) -> void:
	for i in get_all_children(node):
		if i is Label:
			i.add_theme_color_override("font_color", color)
	
