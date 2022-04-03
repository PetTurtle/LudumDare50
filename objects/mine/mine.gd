extends RigidBody2D

export var texture: Texture

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	get_tree().current_scene.explode(self, texture)
	queue_free()
