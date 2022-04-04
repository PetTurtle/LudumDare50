extends Control


var username := "" setget set_username
var score := 0 setget set_score


func set_username(value):
	username = value


func set_score(value):
	score = value


func _ready():
	$MarginContainer/HBoxContainer/Username.text = username
	$MarginContainer/HBoxContainer/Score.text = str(score)
