extends Label


var trauma = 0
var shake = 15
var target_score := 0
var curr_score := 0
var prev_score := 0


func _ready():
	Global.connect("stats_changed", self, "_on_stats_changed")


func _process(delta):
	trauma = min(max(trauma - delta*1.5, 0), 1)
	rect_position = Vector2((2*randf() - 1)*shake*trauma*trauma, (2*randf() - 1)*shake*trauma*trauma)
	curr_score = lerp(curr_score, target_score, 0.5)
	if curr_score % 10 == 0 and curr_score != 0 and curr_score != prev_score:
		Audio.play("points")
		trauma += 0.9
	prev_score = curr_score
	
	text = str(int(curr_score))


func _on_stats_changed(level, score):
	target_score = level + score
	

