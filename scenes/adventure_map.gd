extends Node2D

signal important_tile_found
signal moved

@onready var background_layer: TileMapLayer = $BackgroundLayer
@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer1
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3

@onready var hero_layer: TileMapLayer = $HeroLayer

var hero_pos: Vector2i # 15, 24 | 11,9
var current_layer: TileMapLayer

var blocking: Array = [
	Vector2i(3, 2) # #
	, Vector2i(11, 2) # +
	, Vector2i(7, 15) # water
	, Vector2i(14, 1) # spike
	, Vector2i(9, 14) # barrel
	, Vector2i(0, 2) # blank space 2
]

var layer_1_pos: Vector2i = Vector2i(15, 24)
var layer_2_pos: Vector2i = Vector2i(11, 9)
var layer_3_pos: Vector2i = Vector2i(41, 12)

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
			hero_pos = layer_1_pos
		3:
			tile_map_layer_2.show()
			current_layer = tile_map_layer_2
			hero_pos = layer_2_pos
		4:
			tile_map_layer_3.show()
			current_layer = tile_map_layer_3
			hero_pos = layer_3_pos
	hero_layer.clear()
	hero_layer.set_cell(hero_pos, 0, Vector2i(2, 0))
			
func move_hero(amount: Vector2i):
	if not blocking.has(current_layer.get_cell_atlas_coords(hero_pos + amount)):
		hero_layer.clear()
		hero_pos += amount
		hero_layer.set_cell(hero_pos, 0, Vector2i(2, 0))
		SoundPlayer.play_sound(SoundPlayer.FOOTSTEP_06)
		moved.emit()
	find_important_cells(hero_pos)
	match current_layer:
		tile_map_layer_1:
			layer_1_pos = hero_pos
		tile_map_layer_2:
			layer_2_pos = hero_pos
		tile_map_layer_3:
			layer_3_pos = hero_pos
	
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
					Vector2i(27, 18):
						important_tile_found.emit("exit")
			tile_map_layer_2:
				match tile_map_layer_2.get_cell_atlas_coords(tile):
					Vector2i(14, 1):
						important_tile_found.emit("spike")
					Vector2i(13, 12):
						important_tile_found.emit("mountain")
					Vector2i(6, 6):
						important_tile_found.emit("frog")
					Vector2i(10, 0):
						important_tile_found.emit("cave")
					Vector2i(11, 2):
						important_tile_found.emit("door")
						important_tile_found.emit("exit")
			tile_map_layer_3:
				match tile_map_layer_3.get_cell_atlas_coords(tile):
					Vector2i(11, 2):
						important_tile_found.emit("door2")
					Vector2i(11, 14):
						important_tile_found.emit("no smoking")
					Vector2i(7, 14):
						important_tile_found.emit("radioactive sign")
					Vector2i(9, 14):
						important_tile_found.emit("radioactive barrel")
					Vector2i(13, 3):
						important_tile_found.emit("chamber")
					Vector2i(5, 2):
						important_tile_found.emit("city")
					Vector2i(14, 9):
						important_tile_found.emit("mech")
						important_tile_found.emit("exit")
					Vector2i(15, 8):
						important_tile_found.emit("mech 2")
						important_tile_found.emit("exit")
