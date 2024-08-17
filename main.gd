extends Node2D

const font_clear = preload("res://assets/cp437_20x20_2.png")
const font_sub = preload("res://assets/cp437_20x20_3.png")
const font_sub_un = preload("res://assets/cp437_20x20_4.png")
const UNSCRAMBLE_THEME = preload("res://unscramble_theme.tres")

const DECIPHER_WINDOW = preload("res://scenes/decipher_window.tscn")
const PUZZLE_WINDOW = preload("res://scenes/puzzle_window.tscn")
const IMAGE_WINDOW = preload("res://scenes/image_window.tscn")

const SCUBA_PHOTO_2 = preload("res://assets/scuba photo 2.jpeg")
const SPIKE_FIELD = preload("res://assets/spike_field.webp")
const POSTIT = preload("res://assets/postit.jpg")

var solves: int = 0

func _ready() -> void:
	# change the label fonts to black
	override_font_color(self, Color.BLACK)
	
	var decipher_window = DECIPHER_WINDOW.instantiate()
	decipher_window.num_letters = 3
	override_font_color(decipher_window, Color.BLACK)
	add_child(decipher_window)
	decipher_window.check_pressed.connect(_on_decipher_window_check_pressed)
	
	var puzzle_window = PUZZLE_WINDOW.instantiate()
	puzzle_window.passcode = ["bach", "back", "scab", "carb", "crab"].pick_random()
	override_font_color(puzzle_window, Color.BLACK)
	add_child(puzzle_window)
	puzzle_window.correct.connect(_on_correct_solve)
	
	var image_window = IMAGE_WINDOW.instantiate()
	image_window.first_texture = POSTIT
	image_window.first_label = "the code is %s" % puzzle_window.passcode
	image_window.first_shader_params = [5, 2.0, 1.6, 1.0, 0.005]
	override_font_color(image_window, Color.BLACK)
	add_child(image_window)
	image_window.add_texture_and_label(SCUBA_PHOTO_2, "scuba diving at garuga beach", [5, 2.8, 0.3, 1.0, 0.008])

func _process(delta: float) -> void:
	pass
	
func _on_correct_solve(pw: String) -> void:
	$Popup.show()
	$Popup/VBoxContainer/Label2.text = "the word was %s" % pw
	if solves < 1:
		$Popup/VBoxContainer/Button.text = "continue"

func _on_button_pressed() -> void:
	if solves < 1:
		next_puzzle()
	else:
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
	
func next_puzzle():
	get_tree().reload_current_scene()
