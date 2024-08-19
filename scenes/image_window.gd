extends Window

@export var first_texture: CompressedTexture2D
@export var first_label: String
@export var first_shader_params: Array

@onready var image: TextureRect = $Control/VBoxContainer/Image
@onready var label: Label = $Control/VBoxContainer/Label

var textures = []
var label_text = []
var params = []

var current = 0

func _ready() -> void:
	#add_texture_and_label(first_texture, first_label, first_shader_params)
	#image.texture = textures[0]
	#label.text = label_text[0]
	#set_shader_params(params[0])
	pass
	

func add_texture_and_label(img: CompressedTexture2D, text: String, parameters: Array):
	textures.append(img)
	label_text.append(text)
	params.append(parameters)
	
	current = textures.size() - 1
	image.texture = textures[current]
	label.text = label_text[current]
	set_shader_params(params[current])

func _on_next_button_pressed() -> void:
	if textures.size() > 1:
		if current < textures.size() - 1:
			current += 1
		else:
			current = 0
		image.texture = textures[current]
		label.text = label_text[current]
		set_shader_params(params[current])

func _on_previous_button_pressed() -> void:
	if textures.size() > 1:
		if current > 0:
			current -= 1
		else:
			current = textures.size() - 1
		image.texture = textures[current]
		label.text = label_text[current]
		set_shader_params(params[current])

func set_shader_params(parameters: Array) -> void:
	image.material.set_shader_parameter("kernel", parameters[0])
	image.material.set_shader_parameter("sigma", parameters[1])
	image.material.set_shader_parameter("k", parameters[2])
	image.material.set_shader_parameter("tau", parameters[3])
	image.material.set_shader_parameter("threshold", parameters[4])
