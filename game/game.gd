extends Node2D

export var boom_texture: Texture

onready var boom: Image = boom_texture.get_data()
onready var terrain = $Terrain
onready var player = $Player


func _process(_delta):
	if Input.is_action_pressed("m1"):
		player.extend_body()

#func _input(event):
#	if event.is_action_pressed("mouse_1"):
#		terrain.erase(boom, Transform2D(0, get_global_mouse_position()))
#	elif event.is_action_pressed("mouse_2"):
#		terrain.draw(boom, Transform2D(0, get_global_mouse_position()))


func _on_player_self_intersect():
	assert(get_tree().change_scene("res://game/game.tscn") == OK)
