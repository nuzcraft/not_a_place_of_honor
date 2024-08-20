extends Node

const CLICK_1 = preload("res://assets/sounds/click1.ogg")
const ROLLOVER_1 = preload("res://assets/sounds/rollover1.ogg")
const CLICK_3 = preload("res://assets/sounds/click3.ogg")
const METAL_CLICK = preload("res://assets/sounds/metalClick.ogg")
const FOOTSTEP_06 = preload("res://assets/sounds/footstep06.ogg")
const BOOK_PLACE_1 = preload("res://assets/sounds/bookPlace1.ogg")
const CAPSULE = preload("res://assets/sounds/Capsule.wav")

@onready var audio_players: Node = $AudioPlayers
@onready var music_players: Node = $MusicPlayers

func play_sound(sound):
	for audioStreamPlayer: AudioStreamPlayer in audio_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func play_music(sound):
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.volume_db = 0
			audioStreamPlayer.play()
			break
			
func stop_music():
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stop()
			
func transition_music(sound):
	var playingStream: AudioStreamPlayer
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if audioStreamPlayer.playing:
			playingStream = audioStreamPlayer
			break
	var notPlayingStream: AudioStreamPlayer
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if not audioStreamPlayer == playingStream:
			notPlayingStream = audioStreamPlayer
			break
	notPlayingStream.volume_db = -80
	notPlayingStream.stream = sound
	if playingStream:
		if not notPlayingStream.stream == playingStream.stream:
			notPlayingStream.play(5.0)
			var tween = get_tree().create_tween()
			tween.tween_property(playingStream, "volume_db", -80, 1.5).set_ease(Tween.EASE_IN_OUT)
			tween.parallel().tween_property(notPlayingStream, "volume_db", 0, 1.5).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(playingStream.stop)
	else:
		notPlayingStream.play()
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(notPlayingStream, "volume_db", 0, 1.5).set_ease(Tween.EASE_IN_OUT)
			
			
