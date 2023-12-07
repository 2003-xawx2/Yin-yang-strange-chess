extends Node2D


var strong_shader:ShaderMaterial = preload("res://entity/enemy/frog/mutation.tres")


func _ready():
	change_modulate($Panel,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate($Panel,0)
	var frogs:Array = $DetectArea.get_overlapping_bodies()
	frogs = frogs.filter(_filter)
	for _frog in frogs:
		var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(_frog,"scale",Vector2.ONE*1.4,1)
		_frog.frider.material = strong_shader
		_frog.hurt_area.damage*=2
	await get_tree().create_timer(1).timeout
	queue_free()


func _filter(_frog:Node2D)->bool:
	if _frog is frog:
		return true
	return false


func settle_fail()->void:
	pass


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
