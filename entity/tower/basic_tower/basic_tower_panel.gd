extends Panel

var reset_position:Vector2
var id:int
var fail_settle_cool_time:float=0.5
var success_settle_cool_time:float = 3
var tower_sprite:Texture:
	set(value):
		$Sprite.texture = value
var basic_tower:PackedScene = preload("res://entity/tower/basic_tower/basic_tower.tscn")
var move_manager:Node

var action_press_key:String = "tower_1"

var current_tilemap:TileMap
var basic_tower_instance:Node2D
var offset:Vector2
var smooth_position:Vector2
var zoom:Vector2
var temp_global_position:Vector2
var if_in_use:=false
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
	reset_position = position
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
	if Global.if_in_game:
		if if_in_use:
			in_game_input(event)
	#else:
		#if event is InputEventMouseButton and event.button_mask == 1:
			#out_game_gui(event)


func _on_gui_input(event:InputEvent):
	if Global.if_in_game:
		if if_in_use:
			in_game_gui(event)
	else:
		out_game_gui(event)


func in_game_input(event:InputEvent)->void:
	if $CoolTimer.time_left>0:
		return
	if event.is_action_pressed(action_press_key):
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


func out_game_gui(event:InputEvent)->void:
	if event is InputEventMouseButton and event.button_mask == 1:
		move_manager.move_in(self)


func in_game_gui(event:InputEvent)->void:
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
				if basic_tower_instance==null:
					settle_fail()
					$ClickTimer.stop() 
					return
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
	basic_tower_instance.try_to_settle()


func settle_fail()->void:
	set_process(false)
	if basic_tower_instance == null:
		return
	basic_tower_instance.settle_fail()
	cool_shadow(fail_settle_cool_time)


func settle_success()->void:
	set_process(false)
#	Global.current_world.remove_child(basic_tower_instance)
#	basic_tower_instance.settle_place.get_parent().add_child(basic_tower_instance)
	basic_tower_instance.settle_success()
	cool_shadow(success_settle_cool_time)


func cool_shadow(time:float)->void:
	$CoolTimer.start(time)
	$AnimationPlayer.speed_scale = 1.0 / time
	$AnimationPlayer.play("cool")


func _on_mouse_entered():
	if_mouse_in = true


func _on_mouse_exited():
	if_mouse_in = false



