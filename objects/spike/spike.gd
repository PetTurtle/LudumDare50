extends Area2D

export var texture: Texture

var falling := false

var boomed := false
onready var sprite := $Sprite as Sprite
onready var ray := $RayCast2D as RayCast2D

func _ready():
	Global.spike_material = sprite.material


func _physics_process(delta):
	if not boomed:
		get_tree().current_scene.explode(sprite, sprite.texture)
		boomed = true
	
	if falling:
		position.y += 50 * delta
		if ray.get_collision_point().distance_to(ray.global_position) < 2:
			shatter()
	elif ray.is_colliding():
		ray.collide_with_bodies = true
		ray.collide_with_areas = false
		falling = true


func shatter():
	get_tree().current_scene.explode(ray, texture)
	Audio.play("boom")
	queue_free()


func _on_area_entered(area):
	if area is Player:
		area.add_velocity(Vector2.DOWN * 100)
	shatter()
