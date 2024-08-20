extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(10, 5)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.2  # Maximum rotation in radians (use sparingly).

var shake_strength = 0.0  # Current shake strength.
var shake_power = 2  # shake exponent. Use [2, 3].

@onready var og_offset = offset
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

func add_shake(amount):
	shake_strength = min(shake_strength + amount, 1.0)

func _process(delta):
	offset = og_offset
	if shake_strength:
		shake_strength = max(shake_strength - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(shake_strength, shake_power)
	var noise_1 = random.randf_range(-1, 1)
	var noise_2 = random.randf_range(-1, 1)
	var noise_3 = random.randf_range(-1, 1)
	rotation = max_roll * amount * noise_1
	offset.x = og_offset.x + (max_offset.x * amount * noise_2)
	offset.y = og_offset.y + (max_offset.y * amount * noise_3)
