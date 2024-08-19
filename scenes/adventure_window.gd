extends Window

signal important_tile_found
signal moved

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var adventure_map: Node2D = $SubViewportContainer/SubViewport/AdventureMap

func _ready() -> void:
	adventure_map.important_tile_found.connect(_on_important_tile_found)
	adventure_map.moved.connect(_on_moved)
	
func _process(delta: float) -> void:
	var next_pos = -adventure_map.hero_pos * 20 + Vector2i(220, 260)
	adventure_map.position.x = move_toward(adventure_map.position.x, next_pos.x, delta*100)
	adventure_map.position.y = move_toward(adventure_map.position.y, next_pos.y, delta*100)
	
func set_active_layer(i: int):
	adventure_map.set_active_layer(i)
	
func _on_important_tile_found(type: String):
	important_tile_found.emit(type)
	
func _on_moved():
	moved.emit()
