extends Node2D


@export var map:Sprite2D
@export_category("camera_move")
@export var acceleration : float = 100
@export var speed :float = 500
@export_category("camera_zoom")
@export var zoom_speed :float = 1
@export var zoom_min_limit:float = 0.8
@export var zoom_max_limit:float = 2

@onready var camera_2d = $Camera2D
@onready var view_size_x = ProjectSettings.get("display/window/size/viewport_width")
@onready var view_size_y = ProjectSettings.get("display/window/size/viewport_height")

var zoom:float
var current_speed:Vector2=Vector2.ZERO

func _ready():
	Global.camera = camera_2d
	#根据地图设置摄像机的边界
	var used :Rect2i =map.get_rect()
	camera_2d.limit_bottom=used.end.y*map.scale.y+map.global_position.y+2
	camera_2d.limit_top=used.position.y*map.scale.y+map.global_position.y-2
	camera_2d.limit_left=used.position.x*map.scale.x+map.global_position.x+2
	camera_2d.limit_right=used.end.x*map.scale.x+map.global_position.x-2
	camera_2d.reset_smoothing()
	#
	zoom = camera_2d.zoom.x


func _process(delta):
	accelerate_to_direction(get_movement(),delta)
	camera_2d.zoom = get_zoom(delta)


func accelerate_to_direction(direction:Vector2,delta:float)->void:
	if position.x>camera_2d.limit_right-view_size_x/2/camera_2d.zoom.x and direction.dot(Vector2.RIGHT)>0 :
		direction.x=0
		current_speed.x = 0
	if position.x<camera_2d.limit_left+view_size_x/2/camera_2d.zoom.x and direction.dot(Vector2.LEFT)>0:
		direction.x=0
		current_speed.x = 0
	if position.y>camera_2d.limit_bottom-view_size_y/2/camera_2d.zoom.x and direction.dot(Vector2.DOWN)>0:
		direction.y=0
		current_speed.y = 0
	if position.y<camera_2d.limit_top+view_size_y/2/camera_2d.zoom.x and direction.dot(Vector2.UP)>0:
		direction.y=0
		current_speed.y = 0
	
	current_speed =current_speed.lerp(direction*speed,1-exp(-delta*acceleration))
	position+=current_speed*delta*acceleration
	
#	position = position.lerp(position+direction*speed,delta*acceleration)


func get_movement()->Vector2:
	var movement_vector:=Vector2.ZERO
	movement_vector.x=Input.get_axis("摄像机左移","摄像机右移")
	movement_vector.y=Input.get_axis("摄像机上移","摄像机下移")
	return movement_vector.normalized()


func get_zoom(delta:float)->Vector2:
	if Input.is_action_pressed("摄像机放大"):
		zoom+=delta*zoom_speed
	if Input.is_action_pressed("摄像机缩小"):
		zoom-=delta*zoom_speed
	if Input.is_action_just_pressed("摄像机放大"):
		zoom+=delta*zoom_speed*5
	if Input.is_action_just_pressed("摄像机缩小"):
		zoom-=delta*zoom_speed*5
	if zoom < zoom_min_limit:
		zoom = zoom_min_limit
	if zoom > zoom_max_limit:
		zoom = zoom_max_limit
	return Vector2(zoom,zoom)
