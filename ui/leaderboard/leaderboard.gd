extends Control

const entry_scene := preload("res://ui/leaderboard/entry.tscn")

var min_score := 0
var username := "Player"

onready var entry_container := $MarginContainer/VBoxContainer/EntryContainer as Control
onready var game := get_tree().current_scene
onready var submit_box := $MarginContainer/VBoxContainer/SubmitBox


func _ready():
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
	var scores := SilentWolf.Scores.scores as Array
	var count = 0

	for score in scores:
		var new_enter := entry_scene.instance()
		new_enter.username = score["player_name"]
		new_enter.score = score["score"]
		min_score = int(score["score"])
		entry_container.add_child(new_enter)
		count += 1
		if count == 6:
			break


func _on_username_text_changed(new_text):
	username = new_text


func _on_submit_pressed():
	$MarginContainer/VBoxContainer/SubmitBox.visible = false
	var score_id = yield(SilentWolf.Scores.persist_score(username, Global.score + Global.level), "sw_score_posted")
	game.set_active(true)


func _on_game_over(msg):
	visible = true
	if Global.score + Global.level <= min_score:
		submit_box.visible = false


func _on_continue_pressed():
	game.set_active(true)
