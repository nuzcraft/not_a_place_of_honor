extends Window

@onready var image: TextureRect = $Control/VBoxContainer/Image
@onready var label: Label = $Control/VBoxContainer/Label

var textures = []
var label_text = []
var params = []

var current = 0

func _ready() -> void:
	pass
	

func add_texture_and_label(img: CompressedTexture2D, text: String, parameters: Array) -> bool:
	if not label_text.has(text):
		textures.append(img)
		label_text.append(text)
		params.append(parameters)

		current = textures.size() - 1
		image.texture = textures[current]
		label.text = label_text[current]
		set_shader_params(params[current])
		SoundPlayer.play_sound(SoundPlayer.METAL_CLICK)
		return true
	return false

func _on_next_button_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_3)
	if textures.size() > 1:
		if current < textures.size() - 1:
			current += 1
		else:
			current = 0
		image.texture = textures[current]
		label.text = label_text[current]
		set_shader_params(params[current])

func _on_previous_button_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_3)
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
	
func clear() -> void:
	current = 0
	textures = []
	label_text = []
	params = []


func _on_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_1)
