extends Node2D

const MAIN = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundPlayer.play_music(SoundPlayer.CAPSULE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_3)
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_packed(MAIN)


func _on_start_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_1)
