extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect


func try_to_settle():
	pass


func settle_success()->void:
	color_rect.modulate.a = 1
	$AnimationPlayer.play("blind")
	await $AnimationPlayer.animation_finished
	queue_free()


func settle_fail()->void:
	pass


func _input(event):
	if event is InputEventMouse:
		var uv_x :float= event.position.x / get_viewport_rect().size.x
		var uv_y :float= event.position.y / get_viewport_rect().size.y
		color_rect.material.set_shader_parameter("uv_x",uv_x)
		color_rect.material.set_shader_parameter("uv_y",uv_y)


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
