class_name TextureTools
extends Object

var offset: Vector2
var bitmap := BitMap.new()

var _image: Image
var _image_rect: Rect2
var _sprite: Sprite
var _texture := ImageTexture.new()


func _init(sprite: Sprite, wall_sprite: Sprite, back_sprite: Sprite, noise: OpenSimplexNoise, height: float, level: float):
	_sprite = sprite
	_image = sprite.texture.get_data()
	
	var wall_image := wall_sprite.texture.get_data()
	var back_image := back_sprite.texture.get_data()
	
	_image.lock()
	wall_image.lock()
	back_image.lock()
	var img_size := _image.get_size()
	for x in range(img_size.x):
		for y in range(img_size.y):
			var point := Vector2(x, y)
			var noise_val := noise.get_noise_2d(point.x, point.y + height)
			if noise_val < Global.challange - 0.1:
				back_image.set_pixelv(point, Color(0, 0, 0, 0))
			if noise_val < Global.challange:
				_image.set_pixelv(point, Color(0, 0, 0, 0))
				wall_image.set_pixelv(point, Color(0, 0, 0, 0))
				
	_image.unlock()
	wall_image.unlock()
	back_image.unlock()

	var wall_texture := ImageTexture.new()
	wall_texture.create_from_image(wall_image)
	wall_sprite.texture = wall_texture

	var back_texture := ImageTexture.new()
	back_texture.create_from_image(back_image)
	back_sprite.texture = back_texture

	_texture.create_from_image(_image)
	_sprite.texture = _texture
	_image_rect = Rect2(Vector2.ZERO, _image.get_size())
	bitmap.create_from_image_alpha(_image)
	
	offset = _sprite.offset
	if _sprite.centered:
		offset += _image_rect.end * 0.5

func erase_rect(rect: Rect2, damage_map: Image, map_trans: Transform2D) -> int:
	var erased := 0
	var map_rect := Rect2(Vector2.ZERO, damage_map.get_size())
	_image.lock()
	damage_map.lock()
	
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var point: Vector2 = Vector2(x, y)
			var map_point: Vector2 = map_trans.xform(point)
			if map_rect.has_point(map_point) and _image_rect.has_point(point):
				if damage_map.get_pixelv(map_point).a > 0 and _image.get_pixelv(point).a != 0:
					erased += 1
					bitmap.set_bit(point, false)
					_image.set_pixelv(point, Color(0, 0, 0, 0))
	_remove_floating_pixels(rect)
	
	_image.unlock()
	damage_map.unlock()
	_texture.create_from_image(_image)
	return erased


func draw_rect(rect: Rect2, damage_map: Image, map_trans: Transform2D) -> int:
	var drawed := 0
	var map_rect := Rect2(Vector2.ZERO, damage_map.get_size())
	_image.lock()
	damage_map.lock()
	
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var point: Vector2 = Vector2(x, y)
			var map_point: Vector2 = map_trans.xform(point)
			if map_rect.has_point(map_point) and _image_rect.has_point(point):
				if damage_map.get_pixelv(map_point).a > 0 and _image.get_pixelv(point).a == 0:
					drawed += 1
					bitmap.set_bit(point, true)
					_image.set_pixelv(point, damage_map.get_pixelv(map_point))
	_remove_floating_pixels(rect)
	
	_image.unlock()
	damage_map.unlock()
	_texture.create_from_image(_image)
	return drawed


func _remove_floating_pixels(rect: Rect2):
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var point: Vector2 = Vector2(x, y)
			if _image_rect.has_point(point) and get_pixel_neighbour_count(point) == 0:
				_image.set_pixelv(point, Color(0, 0, 0, 0))
				bitmap.set_bit(point, false)


func get_pixel_neighbour_count(point: Vector2) -> int:
	var count := int(has_point(point + Vector2.UP)) + int(has_point(point + Vector2.DOWN))
	count += int(has_point(point + Vector2.LEFT)) + int(has_point(point + Vector2.RIGHT))
	return count


func has_point(point: Vector2) -> bool:
	if _image_rect.has_point(point) and bitmap.get_bit(point):
		return true
	return false
