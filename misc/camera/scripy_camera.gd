extends Node2D


@export var map:Sprite2D
@export_category("camera_move")
@export var acceleration : float = 100
@export var speed :float = 1000
@export_range(0,1) var zoom_adjust_percent:float=.5
@export_category("camera_zoom")
@export var zoom_speed :float = 1
@export var zoom_min_limit:float = 0.8
@export var zoom_max_limit:float = 2

@onready var camera_2d = $Camera2D
@onready var view_size_x = ProjectSettings.get("display/window/size/viewport_width")
@onready var view_size_y = ProjectSettings.get("display/window/size/viewport_height")

var zoom:float
var current_speed:Vector2=Vector2.ZERO
var tween:Tween
var target_offset:Vector2

var limit_bottom:float
var limit_top:float
var limit_left:float
var limit_right:float


func _ready():
	Global.camera = camera_2d
	#根据地图设置摄像机的边界
	var used :Rect2i =map.get_rect()
	limit_bottom=used.end.y*map.scale.y+map.global_position.y+2
	limit_top=used.position.y*map.scale.y+map.global_position.y-2
	limit_left=used.position.x*map.scale.x+map.global_position.x+2
	limit_right=used.end.x*map.scale.x+map.global_position.x-2
	camera_2d.limit_bottom = limit_bottom
	camera_2d.limit_top = limit_top
	camera_2d.limit_left = limit_left
	camera_2d.limit_right = limit_right
	camera_2d.reset_smoothing()
	#
	zoom = camera_2d.zoom.x


func _process(delta):
	var temp_zoom = get_zoom(delta)
	camera_2d.zoom = camera_2d.zoom.lerp(temp_zoom,1-exp(-delta*acceleration))
	target_offset = target_offset.lerp(Vector2.ZERO,1-exp(-delta*acceleration*2))
	if tween !=null:
		if tween.is_running():
			return
	position+=target_offset
	accelerate_to_direction(get_movement(),delta)


func accelerate_to_direction(direction:Vector2,delta:float)->void:
	direction = direction.normalized()
	if position.x>=limit_right-view_size_x/2/camera_2d.zoom.x and current_speed.dot(Vector2.RIGHT)>0 :
		position.x=limit_right-view_size_x/2/camera_2d.zoom.x
		direction.x=0
		current_speed.x = 0
#		correct_global_position()
	if position.x<=limit_left+view_size_x/2/camera_2d.zoom.x and current_speed.dot(Vector2.LEFT)>0:
		position.x=limit_left+view_size_x/2/camera_2d.zoom.x
		direction.x=0
		current_speed.x = 0
#		correct_global_position()
	if position.y>=limit_bottom-view_size_y/2/camera_2d.zoom.x and current_speed.dot(Vector2.DOWN)>0:
		position.y=limit_bottom-view_size_y/2/camera_2d.zoom.x
		direction.y=0
		current_speed.y = 0
#		correct_global_position()
	if position.y<=limit_top+view_size_y/2/camera_2d.zoom.x and current_speed.dot(Vector2.UP)>0:
		position.y=limit_top+view_size_y/2/camera_2d.zoom.x
		direction.y=0
		current_speed.y = 0
#		correct_global_position()
	
	current_speed =current_speed.lerp(direction*speed,1-exp(-delta*acceleration))
	position+=current_speed*delta


func get_movement()->Vector2:
	var movement_vector:=Vector2.ZERO
	movement_vector.x=Input.get_axis("摄像机左移","摄像机右移")
	movement_vector.y=Input.get_axis("摄像机上移","摄像机下移")
	return movement_vector


func get_zoom(delta:float)->Vector2:
	if Input.is_action_pressed("摄像机放大"):
		zoom+=delta*zoom_speed
		correct_global_position()
	if Input.is_action_pressed("摄像机缩小"):
		zoom-=delta*zoom_speed
		correct_global_position()
	if Input.is_action_just_pressed("摄像机放大"):
		zoom+=delta*zoom_speed*5
		correct_global_position()
	if Input.is_action_just_pressed("摄像机缩小"):
		zoom-=delta*zoom_speed*5
		correct_global_position()
	if zoom < zoom_min_limit:
		zoom = zoom_min_limit
	if zoom > zoom_max_limit:
		zoom = zoom_max_limit
	return Vector2(zoom,zoom)


func correct_global_position()->void:
	target_offset = map.global_position - global_position
	target_offset *= zoom_adjust_percent
#	if tween!=null and tween.is_running():
#		return
#	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self,"global_position",zoom_adjust_percent*map.global_position\
#	+(1-zoom_adjust_percent)*global_position,.2)
