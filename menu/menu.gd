extends Node2D

const game_scene := preload("res://game/game.tscn")

func load_game():
	get_tree().change_scene_to(game_scene)
