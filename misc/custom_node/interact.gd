extends Area2D
class_name interact_area

signal interact

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		_interact()


func _interact()->void:
	interact.emit()
