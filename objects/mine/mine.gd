extends RigidBody2D

var beep_count := 0
var aa_area = null

export var texture: Texture


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if aa_area == null:
		aa_area = area
		$Timer.start()


func _on_Timer_timeout():
	if beep_count == 4:
		get_tree().current_scene.explode(self, texture)
		if aa_area is Player:
			var distance := global_position.distance_to(aa_area.global_position)
			if distance < 120:
				var power = 1 - (distance / 120) + 0.5
				aa_area.add_velocity(global_position.direction_to(aa_area.global_position) * 1000 * power)
		Audio.play("boom")
		Effects.play("boom", global_position)
		$Timer.stop()
		queue_free()
	else:
		Audio.play("beep")
		beep_count += 1
