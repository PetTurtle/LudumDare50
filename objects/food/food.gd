extends RigidBody2D


func _on_Area2D_area_entered(area):
	area.health += 32.0
	Audio.play("coin")
	Effects.play("green", global_position)
	Global.set_score(Global.score + 4)
	queue_free()
