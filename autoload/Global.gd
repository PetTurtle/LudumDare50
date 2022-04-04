extends Node

signal stats_changed(level, score)

var MAX := 0.4
var MIN := 0.25

var challange_dir := 1
var challange_force := 0.02

var challange := -0.05
var challange_color := 0.0
var challange_material: ShaderMaterial = null
var challange_wall_material: ShaderMaterial = null
var challange_back_material: ShaderMaterial = null
var spike_material: ShaderMaterial = null
var max_challange := 0.2
var min_challange := 0.1

var level := 0 setget set_level
var score := 0 setget set_score

func reset():
	level = 0
	score = 0
	challange = -0.05
	challange_color = 0
	max_challange = 0.1
	min_challange = 0.0
	challange_material = null
	challange_wall_material = null
	challange_back_material = null
	spike_material = null


func _process(delta):
	challange_color = max(0, lerp(challange_color, challange, delta))
	if challange_material:
		challange_material.set_shader_param("challange", challange_color * 10)
		challange_wall_material.set_shader_param("challange", challange_color * 10)
		challange_back_material.set_shader_param("challange", challange_color * 10)
	if spike_material:
		spike_material.set_shader_param("challange", challange_color * 10)


func step():
	challange += challange_force * challange_dir
	
	if (challange_force > 0):
		if (challange > max_challange):
			max_challange = min(MAX, max_challange + 0.025)
			challange_force = -challange_force
	else:
		if (challange < min_challange):
			min_challange = min(MIN, min_challange + 0.012)
			challange_force = -challange_force
	#print(min_challange, " < ", challange, " < ", max_challange)


func set_level(value):
	level = max(level, value)
	emit_signal("stats_changed", level, score)


func set_score(value):
	score = max(score, value)
	emit_signal("stats_changed", level, score)
