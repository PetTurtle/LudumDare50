extends RigidBody2D


func _on_Area2D_area_entered(area):
	area.health += 32.0
	queue_free()
