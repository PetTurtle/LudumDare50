extends Node2D

export var boom_texture: Texture

const terrain_height := 180
const terrain_scene := preload("res://terrain/terrain.tscn")

var game_seed := 0
var water_speed := 30.0
var water_acceleration := 0.1
var new_terrain_on_y = 0

onready var player = $Player
onready var water = $Water
onready var camera = $Camera2D
onready var terrains = []
onready var boom: Image = boom_texture.get_data()

func _init():
	randomize()
	game_seed = randi()


func _ready():
	_create_terrain(-180)
	_create_terrain(0)
	_create_terrain(180)


func _process(delta):
	if player.global_position.y <= new_terrain_on_y:
		new_terrain_on_y -= terrain_height
		_create_terrain(new_terrain_on_y - terrain_height)
	water_speed += water_acceleration * delta
	water.position.y -= water_speed * delta
	camera.limit_bottom = water.position.y + 64
	
	if terrains.front().position.y > camera.limit_bottom:
		var terrain := terrains.pop_front() as Node2D
		terrain.queue_free()


func _physics_process(delta):
	_erase_terrain()



func _erase_terrain() -> int:
	var erased := 0
	for terrain in terrains:
		erased += terrain.erase(boom, Transform2D(0, player.global_position))
	return erased


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


func _on_player_self_intersect():
	assert(get_tree().change_scene("res://game/game.tscn") == OK)
