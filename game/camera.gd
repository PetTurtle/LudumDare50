extends Camera2D


onready var water = get_parent().get_node("Water")


func _process(_delta):
	position.y = water.global_position.y - 180
