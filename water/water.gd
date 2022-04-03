extends Area2D


func _on_Water_area_entered(area):
	if area is Player:
		get_tree().current_scene.game_over("Took a swim!")
