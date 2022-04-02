class_name Terrain
extends StaticBody2D

export(float) var detail := 2.0
export(NodePath) var sprite_path: NodePath
export(Vector2) var block_size := Vector2(32, 32)

var block_tree: QuadTree
var collision_tree: QuadTree
var texture_tools: TextureTools

var block_size_half := block_size * 0.5
var block_size_query := block_size * 6

onready var sprite: Sprite = get_node(sprite_path)
onready var collisions := []


func _ready():
	var noise := OpenSimplexNoise.new()
	noise.seed = get_tree().current_scene.game_seed
	var noise_image := noise.get_image(640, 360, position)
	texture_tools = TextureTools.new(sprite, noise_image)
	block_tree = QuadTree.new(Rect2(Vector2.ZERO, sprite.texture.get_size()), 5, 5)
	collision_tree = QuadTree.new(Rect2(Vector2.ZERO, sprite.texture.get_size()), 5, 5)
	_generate_collidors()


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
	for x in range(0, size.x, block_size.x):
		for y in range(0, size.y, block_size.y):
			var point := Vector2(x, y)
			var rect := Rect2(point, block_size)
			var local_offset := point + block_size_half
			block_tree.insert(local_offset, [rect, local_offset])
			for polygon in texture_tools.bitmap.opaque_to_polygons(rect, detail):
				var collision = _create_collision(polygon, Vector2(x,-y))
				collision_tree.insert(local_offset, [collision, local_offset, rect])


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
