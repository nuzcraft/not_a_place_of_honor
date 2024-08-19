extends Node2D

const font_clear = preload("res://assets/cp437_20x20_2.png")
const font_sub = preload("res://assets/cp437_20x20_3.png")
const font_sub_un = preload("res://assets/cp437_20x20_4.png")
const UNSCRAMBLE_THEME = preload("res://unscramble_theme.tres")
const ADVENTURE_WINDOW = preload("res://scenes/adventure_window.tscn")

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
const DOUBLEBLASTDOORS = preload("res://assets/Doubleblastdoors.webp")
const NO_SMOKING = preload("res://assets/no smoking.jpg")
const RADIOACTIVE = preload("res://assets/radioactive.jpg")
const RADIOACTIVE_BARREL = preload("res://assets/radioactive_barrel.jpg")
const AMORED_CORE = preload("res://assets/amored_core.webp")
const ARMORED_CORE_2 = preload("res://assets/armored core 2.webp")
const HL_2_CHAMBER = preload("res://assets/hl2chamber.jpg")
const FF_7 = preload("res://assets/ff7.webp")

var puzzle_number: int = 1

var puzzle_window: Window
var image_window: Window
var adventure_window: Window

func _ready() -> void:
	# change the label fonts to black
	override_font_color(self, Color.BLACK)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	#start_puzzle(puzzle_number)
	Dialogic.start("intro_timeline")

func _process(delta: float) -> void:
	pass
	
func _on_dialogic_signal(st: String) -> void:
	match st:
		"note":
			start_puzzle(puzzle_number)
		"scuba":
			image_window.add_texture_and_label(SCUBA_PHOTO_2, "scuba diving at garuga beach", [5, 2.8, 0.3, 1.0, 0.008])
	
func _on_correct_solve(pw: String) -> void:
	$Popup.show()
	$Popup/VBoxContainer/Label2.text = "the word was %s" % pw
	if puzzle_number < 4:
		$Popup/VBoxContainer/Button.text = "continue"
	else:
		$Popup/VBoxContainer/Label.text = "you won!"
		$Popup/VBoxContainer/Label2.text = "and stole a mech"
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
			
			puzzle_window = PUZZLE_WINDOW.instantiate()
			puzzle_window.passcode = ["bach", "back", "scab", "carb", "crab"].pick_random()
			override_font_color(puzzle_window, Color.BLACK)
			add_child(puzzle_window)
			puzzle_window.correct.connect(_on_correct_solve)
			
			image_window = IMAGE_WINDOW.instantiate()
			override_font_color(image_window, Color.BLACK)
			add_child(image_window)
			image_window.add_texture_and_label(POSTIT, "the code is %s" % puzzle_window.passcode, [5, 2.0, 1.6, 1.0, 0.005])
			#image_window.add_texture_and_label(SCUBA_PHOTO_2, "scuba diving at garuga beach", [5, 2.8, 0.3, 1.0, 0.008])
			
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
			
			puzzle_window.set_passcode(["dance", "cadet", "cedar", "raced", "decay"].pick_random())
			puzzle_window.hide()
			
			image_window.hide()
			image_window.clear()
			
			adventure_window = ADVENTURE_WINDOW.instantiate()
			add_child(adventure_window)
			adventure_window.set_active_layer(puzzle_number)
			adventure_window.important_tile_found.connect(_on_important_tile_found)
			adventure_window.moved.connect(_on_moved)
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
			
			puzzle_window.set_passcode(["wharf", "faith", "flash", "bride", "build", "famed", "faked"].pick_random())
			puzzle_window.hide()
			
			image_window.hide()
			image_window.clear()
			
			adventure_window.set_active_layer(puzzle_number)
			
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
			
			puzzle_window.set_passcode(["babes", "cabin", "eagle", "facet", "hacks", "macaw", "nacho", "oaken", "rabid", "sable", "udder", "wacky", "xenon", "yacht"].pick_random())
			puzzle_window.hide()
			
			image_window.hide()
			image_window.clear()
			
			adventure_window.set_active_layer(puzzle_number)
			
func _on_important_tile_found(type: String):	
	match type:
		"breakfast":
			image_window.show()
			var new = image_window.add_texture_and_label(BACON_EGGS, "uneaten bacon and eggs", [5, 2.0, 5.0, 1.0, 0.005])
			if new: 
				image_window.grab_focus()
				Dialogic.start("bfast_timeline")
			
		"terminal":
			image_window.show()
			var new = image_window.add_texture_and_label(TERMINAL, "computer terminal with no power", [5, 2.0, 1.6, 1.0, 0.005])
			if new: 
				image_window.grab_focus()
				Dialogic.start("terminal_timeline")
		"exit":
			puzzle_window.show()
			adventure_window.grab_focus()
		"spike":
			image_window.show()
			var new = image_window.add_texture_and_label(SPIKE_FIELD, "this place is not a place\nof honor", [5, 2.0, 0.5, 1.0, 0.01])
			if new: image_window.grab_focus()
		"mountain":
			image_window.show()
			var new = image_window.add_texture_and_label(MOUNTAIN, "uragaan mountain range", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"frog":
			image_window.show()
			var new = image_window.add_texture_and_label(MOUNTAIN_FROG, "mountain frog", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"cave":
			image_window.show()
			var new = image_window.add_texture_and_label(CAVE, "cave entrance", [6, 3.8, 1.3, 1.0, 0.005])
			if new: image_window.grab_focus()
		"door":
			image_window.show()
			var new = image_window.add_texture_and_label(BLAST_DOORS_CLOSED, "a great locked blast door", [5, 2, 1.6, 1.0, 0.003])
			if new: image_window.grab_focus()
		"door2":
			image_window.show()
			var new = image_window.add_texture_and_label(DOUBLEBLASTDOORS, "a great unlocked blast door", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"no smoking":
			image_window.show()
			var new = image_window.add_texture_and_label(NO_SMOKING, "no smoking", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"radioactive sign":
			image_window.show()
			var new = image_window.add_texture_and_label(RADIOACTIVE, "caution radioactive", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"radioactive barrel":
			image_window.show()
			var new = image_window.add_texture_and_label(RADIOACTIVE_BARREL, "barrels of radioactive waste", [5, 2.0, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"chamber":
			image_window.show()
			var new = image_window.add_texture_and_label(HL_2_CHAMBER, "unconscionable experiments\nwere performed here", [5, 2, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
		"city":
			image_window.show()
			var new = image_window.add_texture_and_label(FF_7, "theres a whole dang city\ndown here", [5, 0.7, 2.5, 1.0, 0.005])
			if new: image_window.grab_focus()
		"mech":
			image_window.show()
			var new = image_window.add_texture_and_label(AMORED_CORE, "a great mech suit in a hangar", [5, 0.6, 3.5, 1.0, 0.003])
			if new: image_window.grab_focus()
		"mech 2":
			image_window.show()
			var new = image_window.add_texture_and_label(ARMORED_CORE_2, "a terrifying mech suit tank", [5, 2, 1.6, 1.0, 0.005])
			if new: image_window.grab_focus()
			
func _on_moved():
	puzzle_window.hide()
