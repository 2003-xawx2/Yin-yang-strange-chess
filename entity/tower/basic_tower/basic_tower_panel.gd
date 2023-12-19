extends Panel

var id:int
var description:String:
	set(value):
		$InformationPanel/HBoxContainer/Label.text = value
var consume:Dictionary:
	set(value):
		consume = value
		configure_inform()
	get:
		return consume
var reset_position:Vector2
var fail_settle_cool_time:float=0.5
var success_settle_cool_time:float = 3
var tower_sprite:Texture:
	set(value):
		$Sprite.texture = value
var basic_tower:PackedScene = preload("res://entity/tower/basic_tower/basic_tower.tscn")
var move_manager:Node
var action_press_key:int = 1

@export var click_modulate:Color
@export var not_consumed_color:Color

@onready var information_panel = $InformationPanel
@onready var item_win_container = $InformationPanel/HBoxContainer/VBoxContainer
var item_win : = preload("res://ui/in_game_ui/item/item_display_win.tscn")
#var current_tilemap:TileMap
var basic_tower_instance:Node2D
var offset:Vector2
var smooth_position:Vector2
var zoom:Vector2
var temp_global_position:Vector2
var if_in_use:=false
var if_mouse_in:bool = false
var click:bool = false:
	set(value):
		if self_modulate == not_consumed_color:
			click = false
			return
		click = value
		if value == true:
			$Sprite.modulate = click_modulate
			self_modulate = click_modulate
			pass
		else:
			$Sprite.modulate = Color.WHITE
			self_modulate = Color.WHITE
var if_can_consume:bool = false:
	set(value):
		if_can_consume = value
		if value == false:
			$Sprite.modulate = not_consumed_color
			self_modulate = not_consumed_color
		else:
			$Sprite.modulate = Color.WHITE
			self_modulate = Color.WHITE


func _ready():
	information_panel.modulate.a = 0
	reset_position = position
	$CoolColor.scale.y=0
	Global.start_game.connect(try_to_consume)
	Global.item.changed.connect(try_to_consume)
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
	else:
		if event is InputEventMouseButton and event.button_mask == 1:
			var x:float=event.position.x-global_position.x
			var y:float=event.position.y-global_position.y
			if x>0 and x<120 and y>0 and y <120:
				out_game_gui(event)


func _on_gui_input(event:InputEvent):
	if Global.if_in_game:
		if if_in_use:
			in_game_gui(event)
	#else:
		#out_game_gui(event)


func in_game_input(event:InputEvent)->void:
	if $CoolTimer.time_left>0:
		return
	if event.is_action_pressed(str(action_press_key)):
		click = true if click == false else false
		if click == true and try_to_consume():
			for tower_panel in get_tree().get_nodes_in_group("tower_panel"):
				tower_panel.settle_fail()
				tower_panel.click = false
			click = true
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
			if click != true and try_to_consume():
				try_to_settle()
			$ClickTimer.start()
			
		if event.button_mask == 0:
			if if_mouse_in and $ClickTimer.wait_time - $ClickTimer.time_left < .2 and try_to_consume():
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
	_consume()
	set_process(false)
	basic_tower_instance.settle_success()
	basic_tower_instance = null
	cool_shadow(success_settle_cool_time)



func cool_shadow(time:float)->void:
	$CoolTimer.start(time)
	$AnimationPlayer.speed_scale = 1.0 / time
	$AnimationPlayer.play("cool")


func _on_mouse_entered():
	if_mouse_in = true
	$InformationPanel/HoverTimer.start()


func _on_mouse_exited():
	if_mouse_in = false
	$InformationPanel/HoverTimer.stop()
	change_modulate(information_panel,0)


func try_to_consume()->bool:
	if Global.if_in_game == false:
		return true
	var flag := true
	#var index:=0
	for i in consume.keys():
		if consume[i] > Global.item.item_amounts[Global.item.item_dictionary[dropper.drop_dic[i]]]:
			flag = false
			break
	if_can_consume = flag
	return flag


func _consume()->void:
	for i in consume.keys():
		Global.item.collect(dropper.drop_dic[i], -consume[i])


func configure_inform()->void:
	for key in consume.keys():
		if consume[key]!=0:
			var win = item_win.instantiate()
			item_win_container.add_child(win)
			win.sprite = dropper.drop_sprite[dropper.drop_dic[key]]
			win.text = consume[key]


func _on_hover_timer_timeout():
	if Global.if_in_game:
		change_modulate(information_panel,1)


func change_modulate(object,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
