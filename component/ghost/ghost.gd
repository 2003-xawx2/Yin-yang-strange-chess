extends Sprite2D
var fade_time = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"modulate:a",0.0,fade_time)
	await tween.finished
	queue_free()
