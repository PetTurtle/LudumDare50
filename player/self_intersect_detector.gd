extends Area2D

const COLLIDER_SCENE = preload("res://player/body_collidors.tscn")

var colliders := []
var min_points := 8

onready var parent := get_parent() as Line2D


func _process(_delta):
	for i in range(colliders.size()):
		colliders[i].global_position = parent.points[i+min_points]


func _on_extended_body():
	if parent.points.size() > min_points:
		var collider = COLLIDER_SCENE.instance()
		collider.global_position = parent.points[parent.points.size()-1]
		colliders.append(collider)
		add_child(collider)


func _on_shrunk_body():
	while colliders.size() > parent.points.size() - min_points:
		colliders[colliders.size()-1].queue_free()
		colliders.remove(colliders.size()-1)
