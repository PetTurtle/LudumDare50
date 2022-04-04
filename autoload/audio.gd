extends Node

const streams := {
	"boom" : preload("res://assets/audio/boom.wav"),
	"coin" : preload("res://assets/audio/coin.wav"),
	"points" : preload("res://assets/audio/health.wav"),
	"hit" : preload("res://assets/audio/hit.wav"),
	"boost" : preload("res://assets/audio/boost.wav"),
	"beep" : preload("res://assets/audio/beep.wav")
}

const music := preload("res://assets/music.wav")

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.stream = music
	music_player.volume_db = -5
	add_child(music_player)
	music_player.play()

func play(audio_name: String):
	var player := AudioStreamPlayer.new()
	player.stream = streams[audio_name]
	player.connect("finished", self, "_on_finished")
	add_child(player)
	player.play()


func _input(event):
	if event.is_action_pressed("music"):
		if music_player.playing:
			music_player.stop()
		else:
			music_player.play()


func _on_finished():
	for child in get_children():
		if not child.playing and child != music:
			child.queue_free()
			return
