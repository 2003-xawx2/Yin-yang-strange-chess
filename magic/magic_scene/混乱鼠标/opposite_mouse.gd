extends Node2D

@onready var sprite_2d = $Sprite2D
var tex_x:FastNoiseLite = FastNoiseLite.new()
var tex_y:FastNoiseLite = FastNoiseLite.new()
var num:=0
var back_mode:bool = false


func try_to_settle():
	pass



func settle_success()->void:
	sprite_2d.visible = true
	var zoom = Global.camera.zoom
	var offset = Global.camera.global_position-get_viewport_rect().size/2/zoom
	sprite_2d.global_position = get_viewport().get_mouse_position()/zoom+offset
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	set_process(true)
	await get_tree().create_timer(4).timeout
	back_mode = true


func settle_fail()->void:
	pass


func _process(delta):
	var zoom = Global.camera.zoom
	sprite_2d.scale = Vector2.ONE/zoom*1.35
	if back_mode:
		var offset = Global.camera.global_position-get_viewport_rect().size/2/zoom
		sprite_2d.global_position = sprite_2d.global_position.lerp(get_viewport().get_mouse_position()/zoom+offset,delta*3)
		if sprite_2d.global_position.distance_squared_to(get_viewport().get_mouse_position()/zoom+offset)<200:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			queue_free()
	else:
		random_cursor()


func random_cursor()->void:
	num+=1
	var noise_x: = tex_x.get_noise_1d(num)
	var noise_y: = tex_y.get_noise_1d(num)
	sprite_2d.position+=Vector2.ONE.rotated(noise_y*20)*noise_x*10
