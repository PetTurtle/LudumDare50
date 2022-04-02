extends Control

onready var menu: Node = get_tree().current_scene


func _on_play_pressed():
	menu.load_game()
