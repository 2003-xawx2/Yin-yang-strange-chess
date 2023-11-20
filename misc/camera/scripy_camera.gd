extends Node2D


@export var tile_map:TileMap
@export_category("camera_move")
@export var acceleration : float = 100
@export var speed :float = 500
@export_category("camera_zoom")
@export var zoom_speed :float = 1
@export var zoom_max_limit:float =2

@onready var camera_2d = $Camera2D
@onready var view_size_x = ProjectSettings.get("display/window/size/viewport_width")
@onready var view_size_y = ProjectSettings.get("display/window/size/viewport_height")

var zoom:float

func _ready():
	#根据地图设置摄像机的边界
	var used :Rect2i =tile_map.get_used_rect().grow(0)
	var tile_size :Vector2i= tile_map.tile_set.tile_size
	camera_2d.limit_bottom=used.end.y*tile_size.y*tile_map.scale.y
	camera_2d.limit_top=used.position.y*tile_size.y*tile_map.scale.y
	camera_2d.limit_left=used.position.x*tile_size.x*tile_map.scale.x
	camera_2d.limit_right=used.end.x*tile_size.x*tile_map.scale.x
	camera_2d.reset_smoothing()
	#
	zoom = camera_2d.zoom.x


func _process(delta):
	accelerate_to_direction(get_movement(),delta)
	camera_2d.zoom = get_zoom(delta)


func accelerate_to_direction(direction:Vector2,delta:float)->void:
	if position.x>camera_2d.limit_right-view_size_x/2/camera_2d.zoom.x and direction.dot(Vector2.RIGHT)>0 :
		direction.x=0
	if position.x<camera_2d.limit_left+view_size_x/2/camera_2d.zoom.x and direction.dot(Vector2.LEFT)>0:
		direction.x=0
	if position.y>camera_2d.limit_bottom-view_size_y/2/camera_2d.zoom.x and direction.dot(Vector2.DOWN)>0:
		direction.y=0
	if position.y<camera_2d.limit_top+view_size_y/2/camera_2d.zoom.x and direction.dot(Vector2.UP)>0:
		direction.y=0
	position = position.lerp(position+direction*speed,1-exp(-delta*acceleration))


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
	if zoom < 1:
		zoom =1
	if zoom > zoom_max_limit:
		zoom = zoom_max_limit
	return Vector2(zoom,zoom)
