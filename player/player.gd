class_name Player
extends Area2D

signal self_intersect()


export(float) var speed := 80.0
export(float) var boost_speed := 150.0
export(float) var acceleration := 200.0
export(float) var deceleration := 100.0
export(float) var turn_speed := 4.0
export(float) var gravity_force := 2.0

const HEALTH_TO_SIZE := 32.0

var in_terrains := 0
var active := true setget set_active
var move_velocity := speed
var health := 0.0 setget set_health


onready var bodies = [$Body, $BodyShadow]
onready var self_intersect = $Body/SelfIntersect
onready var game = get_tree().current_scene


func set_health(value):
	health = value
	
	if health < -1:
		game.game_over("Became To Small")
	
	for body in bodies:
		body.body_length = 4 + ceil(health / HEALTH_TO_SIZE)


func set_active(value):
	active = value
	set_process(active)
	set_physics_process(active)

func _physics_process(delta: float):
	if in_terrains > 0:
		var boost_throttle := Input.get_action_strength("speed_up")
		var rotation_throttle := Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
		if boost_throttle == 0 or health <= 0:
			move_velocity -= deceleration * delta
		else:
			set_health(max(0, health - 60 * delta))
			move_velocity += boost_throttle * acceleration * delta
		move_velocity = min(boost_speed, max(speed, move_velocity))
		rotation += rotation_throttle * turn_speed * delta
	else:
		var move_dir := ((Vector2.RIGHT * move_velocity).rotated(rotation) + Vector2.DOWN * gravity_force)
		move_velocity = min(boost_speed, max(speed, move_dir.length()))
		rotation = move_dir.angle()
		
	position += (Vector2.RIGHT * move_velocity * delta).rotated(rotation)
	position.x = max(0, min(450, position.x))


func _on_area_entered(area):
	if area == self_intersect:
		game.game_over("Ate Yourself!")


func _on_body_entered(_body):
	in_terrains += 1


func _on_body_exited(_body):
	in_terrains -= 1
