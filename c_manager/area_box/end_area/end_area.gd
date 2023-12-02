extends Area2D
class_name end_area


signal arrived()
 

func _on_body_entered(body):
	#body.free_self()
	arrived.emit()
