extends Camera2D


onready var player = get_parent().get_node("Player")


func _process(_delta):
	position.y = round(player.global_position.y - 180)
