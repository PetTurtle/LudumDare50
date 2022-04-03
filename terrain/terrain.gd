class_name Terrain
extends StaticBody2D

signal generated()

export(float) var detail := 4.0
export(Vector2) var block_size := Vector2(45, 45)

const OBJECTS = [
	preload("res://objects/mine/mine.tscn"),
	preload("res://objects/food/food.tscn")
]

var collisions := []
var block_tree: QuadTree
var collision_tree: QuadTree
var texture_tools: TextureTools
var block_size_half := block_size * 0.5
var block_size_query := block_size * 6

onready var sprite := $Sprite as Sprite
onready var wall_sprite := $WallSprite as Sprite
onready var back_sprite := $BackSprite as Sprite
onready var raycast := $RayCast2D as RayCast2D


func _ready():
	var noise := OpenSimplexNoise.new()
	var level = -1 * (position.y - 180) / 180
	noise.seed = get_tree().current_scene.game_seed
	Global.step()
	Global.level = level
	Global.challange_material = sprite.material
	Global.challange_wall_material = wall_sprite.material
	Global.challange_back_material = back_sprite.material
	texture_tools = TextureTools.new(sprite, wall_sprite, back_sprite, noise, position.y, level)
	
	block_tree = QuadTree.new(Rect2(Vector2.ZERO, sprite.texture.get_size()), 5, 5)
	collision_tree = QuadTree.new(Rect2(Vector2.ZERO, sprite.texture.get_size()), 5, 5)
	_generate_collidors()


func _physics_process(_delta):
	_generate_objects()
	set_physics_process(false)


func draw(damage_map: Image, trans: Transform2D) -> int:
	trans = trans.translated(-damage_map.get_size() * 0.5)
	trans = get_global_transform().translated(-texture_tools.offset).affine_inverse() * trans
	var rect: Rect2 = trans.xform(Rect2(Vector2.ZERO, damage_map.get_size()))
	var drawed := texture_tools.draw_rect(rect, damage_map, trans.inverse())
	_update_colliders(rect)
	return drawed


func erase(damage_map: Image, trans: Transform2D) -> int:
	trans = trans.translated(-damage_map.get_size() * 0.5)
	trans = get_global_transform().translated(-texture_tools.offset).affine_inverse() * trans
	var rect: Rect2 = trans.xform(Rect2(Vector2.ZERO, damage_map.get_size()))
	var erased := texture_tools.erase_rect(rect, damage_map, trans.inverse())
	_update_colliders(rect)
	return erased


func _generate_collidors():
	var size := sprite.texture.get_size() + Vector2(1, 1)
	for y in range(0, size.y, block_size.y):
		for x in range(0, size.x, block_size.x):
			var point := Vector2(x, y)
			var rect := Rect2(point, block_size)
			var local_offset := point + block_size_half
			block_tree.insert(local_offset, [rect, local_offset])
			for polygon in texture_tools.bitmap.opaque_to_polygons(rect, detail):
				var collision = _create_collision(polygon, Vector2(point.x,-point.y))
				collision_tree.insert(local_offset, [collision, local_offset, rect])


func _generate_objects():
	for i in range(randi() % 5):
		raycast.position.x = rand_range(10.0, 440.0)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.get_collision_point().distance_to(raycast.global_position) > 12:
				var object = OBJECTS[randi() % OBJECTS.size()].instance() as Node2D
				add_child(object)
				object.global_position = raycast.get_collision_point()
	raycast.queue_free()
	set_process(false)


func _update_colliders(rect: Rect2):
	var rect_center := (rect.end + rect.position) * 0.5
	var quert_rect = Rect2(rect_center - block_size_query * 0.5, block_size_query)
	var intersected := []
	var results = collision_tree.query(quert_rect)
	for result in results:
		if result[2].intersects(rect):
			collision_tree.remove(result[1], result)
			result[0].queue_free()
			if not intersected.has(result[2]):
				intersected.append(result[2])
	
	var blocks = block_tree.query(quert_rect)
	for block in blocks:
		if block[0].intersects(rect):
			for polygon in texture_tools.bitmap.opaque_to_polygons(block[0], detail):
				var collision = _create_collision(polygon, block[0].position * Vector2(1, -1))
				collision_tree.insert(block[1], [collision, block[1], block[0]])


func _create_collision(polygon: PoolVector2Array, offset: Vector2) -> CollisionPolygon2D:
	var collision = CollisionPolygon2D.new()
	collision.polygon = polygon
	collision.position = offset
	call_deferred("add_child", collision)
	return collision



