class_name QuadTree
extends Resource

var QUAD_NODE := load("res://terrain/quad_node.gd")

var _size: Rect2
var _capacity: int
var _max_depth: int
var _node


func _init(size: Rect2, capacity: int, max_depth: int):
	_size = size
	_capacity = capacity
	_max_depth = max_depth
	_node = QUAD_NODE.new(size, capacity, max_depth, 0)


func insert(point: Vector2, data):
	if _size.has_point(point):
		_node.insert(point, data)


func remove(point: Vector2, data):
	if _size.has_point(point):
		_node.remove(point, data)


func query(area: Rect2) -> Array:
	var found = []
	if _size.intersects(area, true):
		_node.query(area, found)
	return found
