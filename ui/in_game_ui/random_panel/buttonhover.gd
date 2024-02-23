extends TextureButton



@export var hover_color:Color


func _on_mouse_entered() -> void:
	modulate = hover_color


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_button_down() -> void:
	modulate .a = 0


func _on_button_up() -> void:
	modulate .a = 1
