extends Node

export(NodePath) var default_scene_path: NodePath

var _stack := []

onready var _current: Node = get_node(default_scene_path)


func push_menu(menu_scene: PackedScene):
	_stack.push_back(load(_current.filename))
	_current.queue_free()
	_current = menu_scene.instance()
	add_child(_current)


func pop_menu():
	_current.queue_free()
	var menu_scene: PackedScene = _stack.pop_back() as PackedScene
	_current = menu_scene.instance()
	add_child(_current)
