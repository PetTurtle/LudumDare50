class_name Terrain
extends StaticBody2D

export(float) var detail := 2.0
export(NodePath) var sprite_path: NodePath

var texture_tools

onready var sprite: Sprite = get_node(sprite_path)
onready var collisions := []


func _ready():
	texture_tools = TextureTools.new(sprite)
	_update_collider()


func draw(damage_map: Image, trans: Transform2D):
	trans = trans.translated(-damage_map.get_size() * 0.5)
	trans = get_global_transform().translated(-texture_tools.offset).affine_inverse() * trans
	var rect: Rect2 = trans.xform(Rect2(Vector2.ZERO, damage_map.get_size()))
	texture_tools.draw_rect(rect, damage_map, trans.inverse())
	_update_collider()


func erase(damage_map: Image, trans: Transform2D):
	trans = trans.translated(-damage_map.get_size() * 0.5)
	trans = get_global_transform().translated(-texture_tools.offset).affine_inverse() * trans
	var rect: Rect2 = trans.xform(Rect2(Vector2.ZERO, damage_map.get_size()))
	texture_tools.erase_rect(rect, damage_map, trans.inverse())
	_update_collider()


func _update_collider():
	var rect := Rect2(Vector2.ZERO, sprite.texture.get_size())
	for collision in collisions:
		collision.queue_free()
	collisions.clear()
	for polygon in texture_tools.bitmap.opaque_to_polygons(rect, detail):
		collisions.append(_create_collision(polygon))


func _create_collision(polygon: PoolVector2Array) -> CollisionPolygon2D:
	var collision = CollisionPolygon2D.new()
	collision.polygon = polygon
	call_deferred("add_child", collision)
	return collision
