extends Line2D

signal extended_body()
signal shrunk_body()

export var offset := Vector2.ZERO

var body_length: int = 4
var segment_length := 8.0

onready var parent := get_parent() as Node2D


func _ready():
	points[0] = parent.global_position + offset


func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	var last_point = points[points.size() - 1]
	while points.size() < body_length:
		add_point(Vector2(last_point.x, last_point.y))
		emit_signal("extended_body")
	
	while points.size() > body_length:
		remove_point(points.size()-1)
		emit_signal("shrunk_body")
	
	points[0] = parent.global_position  + offset
	for i in range(1, points.size()):
		var distance := points[i-1].distance_to(points[i])
		if distance > segment_length:
			var direction := points[i-1].direction_to(points[i])
			points[i] = points[i-1] + direction * segment_length
