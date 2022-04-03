extends Area2D


func _on_Water_area_entered(area):
	if area is Player:
		var player := area as Player
		player.emit_signal("self_intersect")
