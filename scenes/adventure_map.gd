extends Node2D

signal important_tile_found

@onready var background_layer: TileMapLayer = $BackgroundLayer
@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer1


@onready var hero_layer: TileMapLayer = $HeroLayer

var hero_pos: Vector2i # 15, 24
var current_layer: TileMapLayer

var blocking: Array = [
	Vector2i(3, 2) # #
	, Vector2i(11, 2) # +
]

func _ready() -> void:
	hero_pos = Vector2i(15, 24)

func _process(delta: float) -> void:
	if get_parent().get_parent().get_parent().has_focus():
		if Input.is_action_just_pressed("left"):
			move_hero(Vector2(-1, 0))
		elif Input.is_action_just_pressed("right"):
			move_hero(Vector2(1, 0))
		elif Input.is_action_just_pressed("up"):
			move_hero(Vector2(0, -1))
		elif Input.is_action_just_pressed("down"):
			move_hero(Vector2(0, 1))

func set_active_layer(i: int):
	for lyr in get_children():
		if lyr is TileMapLayer:
			if lyr != background_layer and lyr != hero_layer:
				lyr.hide()
	match i:
		2:
			tile_map_layer_1.show()
			current_layer = tile_map_layer_1
			
func move_hero(amount: Vector2i):
	if not blocking.has(current_layer.get_cell_atlas_coords(hero_pos + amount)):
		hero_layer.clear()
		hero_pos += amount
		hero_layer.set_cell(hero_pos, 0, Vector2i(2, 0))
	find_important_cells(hero_pos)
	
func find_important_cells(pos: Vector2i):
	for tile in current_layer.get_surrounding_cells(pos):
		match current_layer:
			tile_map_layer_1:
				match tile:
					Vector2i(14, 18):
						important_tile_found.emit("breakfast")
					Vector2i(17, 16):
						important_tile_found.emit("terminal")
					Vector2i(18, 16):
						important_tile_found.emit("terminal")
					Vector2i(19, 16):
						important_tile_found.emit("terminal")
					Vector2i(20, 16):
						important_tile_found.emit("terminal")
	# match on layer number and dedicated cell location
	# 14,18 for bfast
	# 17,16 and 18,16 and 19,16 and 20,16
