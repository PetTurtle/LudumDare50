extends Button


func _input(event):
	if event.is_action_pressed("pause"):
		visible = false


func _on_start_pressed():
	visible = false
	get_tree().current_scene.active = true
