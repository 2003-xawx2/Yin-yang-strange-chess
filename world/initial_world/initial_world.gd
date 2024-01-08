extends basic_world



func _on_button_button_down():
	Engine.time_scale = 3


func _on_button_button_up():
	Engine.time_scale = 1


