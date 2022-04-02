extends Area2D

signal self_intersect()

export(float) var max_speed := 100.0
export(float) var min_speed := 60.0
export(float) var acceleration := 50.0
export(float) var deceleration := 100.0
export(float) var turn_speed := 4.0
export(float) var gravity_force := 2.0

var in_terrains := 0
var move_velocity := 0.0

onready var bodies = [$Body, $BodyShadow]
onready var self_intersect = $Body/SelfIntersect


func _physics_process(delta: float):
	if in_terrains > 0:
		var velocity_throttle := Input.get_action_strength("speed_up")
		var rotation_throttle := Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
		move_velocity += velocity_throttle * acceleration * delta
		if velocity_throttle == 0:
			move_velocity -= deceleration * delta
		move_velocity = min(max_speed, max(min_speed, move_velocity))
		rotation += rotation_throttle * turn_speed * delta
	else:
		var move_dir := ((Vector2.RIGHT * move_velocity).rotated(rotation) + Vector2.DOWN * gravity_force)
		move_velocity = min(max_speed, max(min_speed, move_dir.length()))
		rotation = move_dir.angle()
		
	position += (Vector2.RIGHT * move_velocity * delta).rotated(rotation)


func _on_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area == self_intersect:
		print("self_intersect")
	emit_signal("self_intersect")


func _on_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	pass # Replace with function body.


func _on_body_entered(_body):
	in_terrains += 1


func _on_body_exited(_body):
	in_terrains -= 1
