extends Node2D


func load_game():
	assert(get_tree().change_scene("res://game/game.tscn") == OK)
