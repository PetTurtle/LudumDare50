extends Button




func _on_start_pressed():
	visible = false
	get_tree().current_scene.active = true
