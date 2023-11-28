extends Panel


@export var fail_settle_cool_time:float=0.5
@export var success_settle_cool_time:float = 3


@onready var basic_tower :PackedScene = preload("res://entity/tower/basic_tower/basic_tower.tscn")
var current_tilemap:TileMap
var basic_tower_instance:Node2D
var offset:Vector2
var smooth_position:Vector2
var zoom:Vector2
var temp_global_position:Vector2
var if_mouse_in:bool = false
var click:bool = false:
	set(value):
		click = value
		if value == true:
			modulate = Color.BLUE_VIOLET
			pass
		else:
			modulate = Color.WHITE


func _ready():
	$CoolColor.scale.y=0
	set_process(false)


func _process(delta):
	if basic_tower_instance == null:
		return
	offset = Global.camera.global_position-get_viewport_rect().size/2/zoom	
	zoom = Global.camera.zoom
	basic_tower_instance.global_position = get_viewport().get_mouse_position()/zoom+offset
#	var relative:Vector2 = basic_tower_instance.global_position - temp_global_position
#	temp_global_position = basic_tower_instance.global_position
#	if relative.length_squared() > 100:
#		smooth_position = - relative
#	smooth_position = smooth_position.lerp(Vector2.ZERO,1-exp(-delta))
#	basic_tower_instance.global_position += smooth_position


func _input(event):
	if $CoolTimer.time_left>0:
		return
	if event.is_action_pressed("tower_1"):
		click = true if click == false else false
		if click == true:
			try_to_settle()
		else:
			if basic_tower_instance == null:
				return
			if basic_tower_instance.if_has_settle_place == false:
				settle_fail()
			else:
				settle_success()
	if event is InputEventMouseButton and event.button_mask == 1 and click == true:
		if basic_tower_instance.if_has_settle_place == false:
			if if_mouse_in:
				click = true
				return
			else:
				settle_fail()
		else:
			settle_success()
		if !if_mouse_in:
			click = false


func _on_gui_input(event):
	if $CoolTimer.time_left>0:
		return
	if event is InputEventMouseButton:
	#左键摁下
		if event.button_mask == 1:
			if click != true:
				try_to_settle()
			$ClickTimer.start()
			
		if event.button_mask == 0:
			if if_mouse_in and $ClickTimer.wait_time - $ClickTimer.time_left < .2:
				click = true
			else:
				click = false
				if basic_tower_instance.if_has_settle_place == false:
					settle_fail()
				else:
					settle_success()
			$ClickTimer.stop()


func try_to_settle()->void:
	if basic_tower_instance!=null and basic_tower_instance.attracted_to == false:
		basic_tower_instance.queue_free()
	set_process(true)
	basic_tower_instance = basic_tower.instantiate()
	Global.current_world.add_child(basic_tower_instance)
	basic_tower_instance.modulate.a = .5


func settle_fail()->void:
	set_process(false)
	if basic_tower_instance == null:
		return
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(basic_tower_instance,"modulate:a",0,.3).from(.6)
	await tween.finished
	basic_tower_instance.change_modulate(basic_tower_instance.settle_place,1)
	basic_tower_instance.free_self()
	cool_shadow(fail_settle_cool_time)


func settle_success()->void:
	set_process(false)
#	Global.current_world.remove_child(basic_tower_instance)
#	basic_tower_instance.settle_place.get_parent().add_child(basic_tower_instance)
	basic_tower_instance.global_position = basic_tower_instance.settle_place.global_position
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(basic_tower_instance,"modulate:a",1,.3).from(.6)
	basic_tower_instance.attracted_to = true
#	basic_tower_instance.scale = Vector2.ONE*1.0/9
	basic_tower_instance.settle_place.set_unavailable()
	basic_tower_instance.settle_place.tower = basic_tower_instance
	cool_shadow(success_settle_cool_time)


func cool_shadow(time:float)->void:
	$CoolTimer.start(time)
	$AnimationPlayer.speed_scale = 1.0 / time
	$AnimationPlayer.play("cool")


func _on_mouse_entered():
	if_mouse_in = true


func _on_mouse_exited():
	if_mouse_in = false

