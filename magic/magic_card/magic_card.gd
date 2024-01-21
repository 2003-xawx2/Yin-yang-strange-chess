extends Panel

var magic_sprite:Texture:
	set(value):
		$MagicSprite.texture = value
var magic:PackedScene = preload("res://magic/magic_scene/倒转乾坤/taichi.tscn")

@onready var click_timer = $ClickTimer

var magic_instance:Node2D
var offset:Vector2
var zoom:Vector2
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
	set_process(false)
	#await get_parent().get_parent().get_parent().ready
	owner = get_parent().get_parent().get_parent()


func _process(delta):
	if magic_instance == null:
		return
	offset = Global.camera.global_position-get_viewport_rect().size/2/zoom
	zoom = Global.camera.zoom
	magic_instance.global_position = get_viewport().get_mouse_position()/zoom+offset
	#magic_instance.global_position = get_viewport().get_mouse_position()


func _input(event):
	in_game_input(event)


func _on_gui_input(event:InputEvent):
	in_game_gui(event)


func in_game_input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.button_mask == 1 and click == true:
		if if_mouse_in:
			settle_fail()
		else:
			settle_success()
			click = false


func in_game_gui(event:InputEvent)->void:
	if event is InputEventMouseButton:
	#左键摁下
		if event.button_mask == 1:
			try_to_settle()
			click_timer.start()

		if event.button_mask == 0:
			if click_timer.wait_time-click_timer.time_left<.5:
				click = true
			else:
				click = false
			if click == false:
				if if_mouse_in:
					settle_fail()
				else:
					settle_success()
			click_timer.stop()



func try_to_settle()->void:
	if magic_instance!=null:
		magic_instance.queue_free()
	set_process(true)
	magic_instance = magic.instantiate()
	Global.current_world.add_child(magic_instance)
	magic_instance.try_to_settle()


func settle_fail()->void:
	set_process(false)
	if magic_instance == null:
		return
	magic_instance.settle_fail()
	click = false


func settle_success()->void:
	set_process(false)
	magic_instance.settle_success()
	magic_instance.z_index = 100
	magic_instance = null
	click = false
	get_parent().free_self()


func _on_mouse_entered():
	if_mouse_in = true


func _on_mouse_exited():
	if_mouse_in = false



