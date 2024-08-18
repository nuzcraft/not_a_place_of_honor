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
const BACON_EGGS = preload("res://assets/bacon-eggs.webp")
const TERMINAL = preload("res://assets/terminal.png")
const MOUNTAIN = preload("res://assets/mountain.webp")
const MOUNTAIN_FROG = preload("res://assets/mountain frog.JPG")
const CAVE = preload("res://assets/cave.jpg")
const BLAST_DOORS_CLOSED = preload("res://assets/blast doors closed.jpg")

var puzzle_number: int = 4

func _ready() -> void:
	# change the label fonts to black
	override_font_color(self, Color.BLACK)
	
	start_puzzle(puzzle_number)

func _process(delta: float) -> void:
	pass
	
func _on_correct_solve(pw: String) -> void:
	$Popup.show()
	$Popup/VBoxContainer/Label2.text = "the word was %s" % pw
	if puzzle_number < 4:
		$Popup/VBoxContainer/Button.text = "continue"
	else:
		$Popup/VBoxContainer/Button.text = "restart"
	

func _on_button_pressed() -> void:
	$Popup.hide()
	if puzzle_number < 4:
		puzzle_number += 1
		start_puzzle(puzzle_number)
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
	
func start_puzzle(puzzle_number: int) -> void:
	match puzzle_number:
		1:
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
		2:
			var old_decipher: Window = get_node("DecipherWindow")
			var old_decipher_pos = old_decipher.position
			old_decipher.queue_free()
			var decipher_window = DECIPHER_WINDOW.instantiate()
			decipher_window.position = old_decipher_pos
			decipher_window.num_letters = 5
			override_font_color(decipher_window, Color.BLACK)
			add_child(decipher_window)
			decipher_window.check_pressed.connect(_on_decipher_window_check_pressed)
			
			var old_puzzle: Window = get_node("PuzzleWindow")
			var old_puzzle_pos = old_puzzle.position
			old_puzzle.queue_free()
			var puzzle_window = PUZZLE_WINDOW.instantiate()
			puzzle_window.position = old_puzzle_pos
			puzzle_window.passcode = ["dance", "cadet", "cedar", "raced", "decay"].pick_random()
			override_font_color(puzzle_window, Color.BLACK)
			add_child(puzzle_window)
			puzzle_window.correct.connect(_on_correct_solve)
			
			var old_image: Window = get_node("ImageWindow")
			var old_image_pos = old_image.position
			old_image.queue_free()
			var image_window = IMAGE_WINDOW.instantiate()
			image_window.position = old_image_pos
			image_window.first_texture = BACON_EGGS
			image_window.first_label = "uneaten bacon and eggs"
			image_window.first_shader_params = [5, 2.0, 5.0, 1.0, 0.005]
			override_font_color(image_window, Color.BLACK)
			add_child(image_window)
			image_window.add_texture_and_label(TERMINAL, "computer terminal with no power", [5, 2.0, 1.6, 1.0, 0.005])
		3:
			var old_decipher: Window = get_node("DecipherWindow")
			var old_decipher_pos: Vector2
			if old_decipher:
				old_decipher_pos = old_decipher.position
				old_decipher.queue_free()
			var decipher_window = DECIPHER_WINDOW.instantiate()
			if old_decipher: decipher_window.position = old_decipher_pos
			decipher_window.num_letters = 13
			override_font_color(decipher_window, Color.BLACK)
			add_child(decipher_window)
			decipher_window.check_pressed.connect(_on_decipher_window_check_pressed)
			
			var old_puzzle: Window = get_node("PuzzleWindow")
			var old_puzzle_pos: Vector2
			if old_puzzle:
				old_puzzle_pos = old_puzzle.position
				old_puzzle.queue_free()
			var puzzle_window = PUZZLE_WINDOW.instantiate()
			if old_puzzle: puzzle_window.position = old_puzzle_pos
			puzzle_window.passcode = ["wharf", "faith", "flash", "bride", "build", "famed", "faked"].pick_random()
			override_font_color(puzzle_window, Color.BLACK)
			add_child(puzzle_window)
			puzzle_window.correct.connect(_on_correct_solve)
			
			var old_image: Window = get_node("ImageWindow")
			var old_image_pos: Vector2
			if old_image: 
				old_image_pos = old_image.position
				old_image.queue_free()
			var image_window = IMAGE_WINDOW.instantiate()
			if old_image: image_window.position = old_image_pos
			image_window.first_texture = SPIKE_FIELD
			image_window.first_label = "this place is not a place\nof honor"
			image_window.first_shader_params = [5, 2.0, 0.5, 1.0, 0.01]
			override_font_color(image_window, Color.BLACK)
			add_child(image_window)
			image_window.add_texture_and_label(MOUNTAIN, "uragaan mountain range", [5, 2.0, 1.6, 1.0, 0.005])
			image_window.add_texture_and_label(MOUNTAIN_FROG, "mountain frog", [5, 2.0, 1.6, 1.0, 0.005])
			image_window.add_texture_and_label(CAVE, "cave entrance", [6, 3.8, 1.3, 1.0, 0.005])
			image_window.add_texture_and_label(BLAST_DOORS_CLOSED, "a great locked blast door", [5, 2, 1.6, 1.0, 0.003])
			
		4:
			var old_decipher: Window = get_node("DecipherWindow")
			var old_decipher_pos: Vector2
			if old_decipher:
				old_decipher_pos = old_decipher.position
				old_decipher.queue_free()
			var decipher_window = DECIPHER_WINDOW.instantiate()
			if old_decipher: decipher_window.position = old_decipher_pos
			decipher_window.num_letters = 26
			override_font_color(decipher_window, Color.BLACK)
			add_child(decipher_window)
			decipher_window.check_pressed.connect(_on_decipher_window_check_pressed)
			
			var old_puzzle: Window = get_node("PuzzleWindow")
			var old_puzzle_pos: Vector2
			if old_puzzle:
				old_puzzle_pos = old_puzzle.position
				old_puzzle.queue_free()
			var puzzle_window = PUZZLE_WINDOW.instantiate()
			if old_puzzle: puzzle_window.position = old_puzzle_pos
			puzzle_window.passcode = ["babes", "cabin", "eagle", "facet", "hacks", "macaw", "nacho", "oaken", "rabid", "sable", "udder", "wacky", "xenon", "yacht"].pick_random()
			override_font_color(puzzle_window, Color.BLACK)
			add_child(puzzle_window)
			puzzle_window.correct.connect(_on_correct_solve)
			
			var old_image: Window = get_node("ImageWindow")
			var old_image_pos: Vector2
			if old_image: 
				old_image_pos = old_image.position
				old_image.queue_free()
			var image_window = IMAGE_WINDOW.instantiate()
			if old_image: image_window.position = old_image_pos
			image_window.first_texture = SPIKE_FIELD
			image_window.first_label = "this place is not a place\nof honor"
			image_window.first_shader_params = [5, 2.0, 0.5, 1.0, 0.01]
			override_font_color(image_window, Color.BLACK)
			add_child(image_window)
			#image_window.add_texture_and_label(MOUNTAIN, "uragaan mountain range", [5, 2.0, 1.6, 1.0, 0.005])
			#image_window.add_texture_and_label(MOUNTAIN_FROG, "mountain frog", [5, 2.0, 1.6, 1.0, 0.005])
			#image_window.add_texture_and_label(CAVE, "cave entrance", [6, 3.8, 1.3, 1.0, 0.005])
			#image_window.add_texture_and_label(BLAST_DOORS_CLOSED, "a great locked blast door", [5, 2, 1.6, 1.0, 0.003])
