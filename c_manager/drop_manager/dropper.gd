extends Node2D


@export var type:dropper.Drop = dropper.Drop.bone

var sprite:Texture:
	set(value):
		$Sprite2D.texture = value


func _ready():
	#var direction:Vector2 = Vector2.LEFT.rotated(randf_range(0,PI))
	var tween:=create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2.ONE,.3)
	set_process(false)


func init()->void:
	await get_tree().create_timer(.3).timeout
	var target_global_position:Vector2 = Global.item.item_dictionary[type].global_position/Global.camera.zoom+\
	Global.camera.global_position-get_viewport_rect().size/2/Global.camera.zoom+Vector2.ONE*35
	set_process(true)
	#var tween:=create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	#tween.set_parallel()
	#tween.tween_property(self,"global_position",target_global_position,1.8)
	#tween.chain()
	##tween.tween_interval(1.3)
	##tween.tween_property(self,"scale",Vector2.ZERO,.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	##tween.chain()
	#tween.tween_callback(_on_tween_finished)


func _process(delta):
	var zoom :Vector2 =Global.camera.zoom
	var target_global_position:Vector2 = Global.item.item_dictionary[type].global_position/zoom+\
	Global.camera.global_position-get_viewport_rect().size/2/zoom+Vector2.ONE*35
	$Sprite2D.scale=Vector2.ONE/zoom*5.2
	global_position = global_position.lerp(target_global_position,1-exp(-delta*5))
	
	if global_position.distance_squared_to(target_global_position)<100:
		var tween:=create_tween()
		tween.tween_property(self,"scale",Vector2.ZERO,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.chain()
		tween.tween_callback(_on_tween_finished)
		set_process(false)


func _on_tween_finished()->void:
	Global.item.collect(type)
	queue_free()
