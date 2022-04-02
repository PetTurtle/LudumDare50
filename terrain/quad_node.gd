extends Object

var _rect: Rect2
var _capacity: int
var _max_depth: int
var _depth: int
var _data := {}
var _data_count := 0

var _top_left
var _top_right
var _bottom_left
var _bottom_right
var _subdivided := false


func _init(rect: Rect2, capacity: int, max_depth: int, depth: int = 0):
	_rect = rect
	_capacity = capacity
	_max_depth = max_depth
	_depth = depth


func insert(point: Vector2, data):
	if _data_count < _capacity or _depth >= _max_depth:
		_data[data] = point
		_data_count += 1
	elif _subdivided:
		get_subnode(point).insert(point, data)
	else:
		subdivide()
		get_subnode(point).insert(point, data)


func remove(point: Vector2, data):
	if _data.has(data):
		_data.erase(data)
		_data_count -= 1
	elif _subdivided:
		get_subnode(point).remove(point, data)
		if are_children_empty():
			_top_left = null
			_top_right = null
			_bottom_left = null
			_bottom_right = null
			_subdivided = false


func query(rect: Rect2, found: Array):
	for key in _data:
		if rect.has_point(_data[key]):
			found.append(key)

	if _subdivided and rect.intersects(_rect, true):
		_top_left.query(rect, found)
		_top_right.query(rect, found)
		_bottom_left.query(rect, found)
		_bottom_right.query(rect, found)


func are_children_empty() -> bool:
	return _top_left.is_empty() and _top_right.is_empty() and _bottom_left.is_empty() and _bottom_right.is_empty()


func is_empty() -> bool:
	return _subdivided == false and _data_count == 0


func subdivide():
	var x = _rect.position.x
	var y = _rect.position.y
	var width = _rect.size.x * 0.5
	var height = _rect.size.y * 0.5
	_top_left = get_script().new(Rect2(x, y, width, height), _capacity, _max_depth, _depth + 1)
	_top_right = get_script().new(Rect2(x + width, y, width, height), _capacity, _max_depth,  _depth + 1)
	_bottom_left = get_script().new(Rect2(x, y + height, width, height), _capacity, _max_depth,  _depth + 1)
	_bottom_right = get_script().new(Rect2(x + width, y + height, width, height), _capacity, _max_depth,  _depth + 1)
	_subdivided = true


func get_subnode(point: Vector2):
	var cX = _rect.position.x + _rect.size.x * 0.5
	var cY = _rect.position.y + _rect.size.y * 0.5
	if point.x < cX:
		if point.y < cY:
			return _top_left
		return _bottom_left
	else:
		if point.y < cY:
			return _top_right
		return _bottom_right
