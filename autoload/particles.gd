extends Node

const spawners := {
	"boom" : preload("res://effects/boom.tscn"),
	"green" : preload("res://effects/green.tscn")
}

var frame := 0


func play(spawner_name: String, pos: Vector2):
	var spawner = spawners[spawner_name].instance() as CPUParticles2D
	spawner.position = pos
	spawner.emitting = true
	add_child(spawner)


func _process(delta):
	if frame % 60 == 0:
		for child in get_children():
			if not child.emitting:
				child.queue_free()
				return
	frame += 1
