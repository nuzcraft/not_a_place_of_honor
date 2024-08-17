extends Window

@export var first_texture: CompressedTexture2D
@export var first_label: String

@onready var image: TextureRect = $Control/VBoxContainer/Image
@onready var label: Label = $Control/VBoxContainer/Label

var textures = []
var label_text = []

var current = 0

func _ready() -> void:
	add_texture_and_label(first_texture, first_label)
	image.texture = textures[0]
	label.text = label_text[0]

func add_texture_and_label(img: CompressedTexture2D, text: String):
	textures.append(img)
	label_text.append(text)


func _on_next_button_pressed() -> void:
	if textures.size() > 1:
		if current < textures.size() - 1:
			current += 1
		else:
			current = 0
		image.texture = textures[current]
		label.text = label_text[current]


func _on_previous_button_pressed() -> void:
	if textures.size() > 1:
		if current > 0:
			current -= 1
		else:
			current = textures.size() - 1
		image.texture = textures[current]
		label.text = label_text[current]
