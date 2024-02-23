extends Panel

@onready var item: Panel = $"../Item"


@export var target_position:Vector2

var initial_position:Vector2
var tween:Tween


func _ready() -> void:
	initial_position = item.position


func _on_mouse_entered() -> void:
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(item,"position",target_position,1)


func _on_mouse_exited() -> void:
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(item,"position",initial_position,.5)
