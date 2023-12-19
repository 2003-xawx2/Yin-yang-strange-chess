extends Sprite2D

@onready var ui_operation_container = $UiOperationContainer

var if_has_tower:=false
var tower:Node2D
var tween:Tween


func _ready():
#	ui_operation_container.scale = Vector2.ZERO*.21
	pass


func set_unavailable()->void:
	$DetectArea.monitorable = false
	remove_from_group("tower_container")
	set_deferred("if_has_tower",true)


func set_available()->void:
	$DetectArea.monitorable = true    
	add_to_group("tower_container")
	set_deferred("if_has_tower",false)


func _on_ui_operation_container_gui_input(event):
	if !if_has_tower:
		return
	if tween != null and tween.is_running():
		await tween.finished
	if event is InputEventMouseButton and event.button_mask == 2:
		if ui_operation_container.scale == Vector2.ONE:
			change_ui_scale(Vector2.ONE*.21,0)
		else:
			change_ui_scale(Vector2.ONE,.5)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		change_ui_scale(Vector2.ONE*.21,0)


func _on_texture_button_pressed():
	if ui_operation_container.scale != Vector2.ONE:
		return
	if tween != null and tween.is_running():
		await tween.finished
	tower.free_self()
	change_ui_scale(Vector2.ONE*.21,0)
	set_available()


func change_ui_scale(target_scale:Vector2,target_a:float):
	if tween!=null: tween.kill()
	tween =create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(ui_operation_container,"scale",target_scale,.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(ui_operation_container,"modulate:a",target_a,.2).set_ease(Tween.EASE_IN)
