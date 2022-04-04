extends Node2D

signal game_over(msg)

export var boom_texture: Texture

const terrain_height := 180
const terrain_scene := preload("res://terrain/terrain.tscn")


var game_seed := 0
var water_speed := 40.0
var water_acceleration := 0.1
var new_terrain_on_y = 0

var game_over := false
var active := true setget set_active

onready var player = $Player
onready var water = $Water
onready var camera = $Camera2D
onready var terrains = []
onready var boom: Image = boom_texture.get_data()

func _init():
	randomize()
	game_seed = randi()
	


func _ready():
	_create_terrain(180)
	_create_terrain(0)
	_create_terrain(-180)
	_create_terrain(-360)
	set_active(false)


func _process(delta):
	if player.global_position.y <= new_terrain_on_y:
		new_terrain_on_y -= terrain_height
		_create_terrain(new_terrain_on_y - 2 * terrain_height)
	
	var water_distance = water.global_position.distance_to(player.global_position)
		
	water_speed = min(60, water_speed + water_acceleration * delta)
	water.position.y -= water_speed * water_distance/400 * delta
	camera.limit_bottom = water.position.y + 64
	
	if terrains.front().position.y > camera.limit_bottom:
		var terrain := terrains.pop_front() as Node2D
		terrain.queue_free()


func _input(event):
	if event.is_action_pressed("pause"):
		set_active(not active)


func _physics_process(delta):
	_erase_terrain()


func explode(node: Node2D, texture: Texture):
	var image := texture.get_data()
	for terrain in terrains:
		var _erased = terrain.erase(image, Transform2D(node.rotation, node.global_position))


func set_active(value):
	if game_over:
		value = true
		$CanvasLayer/Transition.close()
	active = value
	set_process(active)
	set_physics_process(active)
	player.set_active(value)


func game_over(msg):
	set_active(false)
	game_over = true
	emit_signal("game_over", msg)
	

func _erase_terrain():
	for terrain in terrains:
		var _erased = terrain.erase(boom, Transform2D(0, player.global_position))


func _draw_terrain() -> int:
	var drawed := 0
	for terrain in terrains:
		drawed += terrain.draw(boom, Transform2D(0, player.global_position))
	return drawed


func _create_terrain(offset: float):
		var new_terrain = terrain_scene.instance()
		new_terrain.position.y = offset
		terrains.append(new_terrain)
		add_child(new_terrain)


func _on_transition_closed():
	Global.reset()
	get_tree().reload_current_scene()
