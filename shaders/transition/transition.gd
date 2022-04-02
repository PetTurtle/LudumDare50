extends Control

signal opened()
signal closed()

export var auto_open := false
export var speed_scale := 1.0

var _backwords := false

onready var _player := $AnimationPlayer as AnimationPlayer


func _ready():
	if auto_open:
		open()


func open():
	_backwords = false
	_player.play("transition", -1, speed_scale, false)


func close():
	_backwords = true
	_player.play("transition", -1, -speed_scale, true)


func _on_animation_player_animation_finished(_anim_name: String):
	if _backwords:
		emit_signal("closed")
	else:
		emit_signal("opened")
