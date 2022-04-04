extends Node2D

onready var tween = $Tween
onready var label = $TextureRect/Label as Label
onready var game = get_tree().current_scene
onready var username = $TextureRect/Username as LineEdit
onready var submit = $TextureRect/Submit as Button


func _process(delta):
	username.rect_rotation = 0
	submit.rect_rotation = 0


func _on_Game_game_over(msg):
	label.text = msg
	var camera := game.get_node("Camera2D") as Node2D
	var player := game.get_node("Player") as Node2D
	global_position.y = camera.position.y
	tween.interpolate_property(self, "global_position",
		camera.global_position, player.global_position, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rotation",
		player.rotation, (randf() * PI/3) - PI/6, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
