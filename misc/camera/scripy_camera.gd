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
	#target_offset = target_offset.lerp(Vector2.ZERO,1-exp(-delta*acceleration*2))
	if tween !=null:
		if tween.is_running():
			return
	#position+=target_offset
	accelerate_to_direction(get_movement(),delta)
	shake_process(delta)


func accelerate_to_direction(direction:Vector2,delta:float)->void:
	direction = direction.normalized()
	if position.x>limit_right-view_size_x/2/camera_2d.zoom.x :
	#and current_speed.dot(Vector2.RIGHT)>0 :
		position.x=limit_right-view_size_x/2/camera_2d.zoom.x
		direction.x=0
		current_speed.x = 0
	if position.x<limit_left+view_size_x/2/camera_2d.zoom.x :
	#and current_speed.dot(Vector2.LEFT)>0:
		position.x=limit_left+view_size_x/2/camera_2d.zoom.x
		direction.x=0
		current_speed.x = 0
	if position.y>limit_bottom-view_size_y/2/camera_2d.zoom.x :
	#and current_speed.dot(Vector2.DOWN)>0:
		position.y=limit_bottom-view_size_y/2/camera_2d.zoom.x
		direction.y=0
		current_speed.y = 0
	if position.y<limit_top+view_size_y/2/camera_2d.zoom.x :
		#and current_speed.dot(Vector2.UP)>0:
		position.y=limit_top+view_size_y/2/camera_2d.zoom.x
		direction.y=0
		current_speed.y = 0
	
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
	#pass
	target_offset = map.global_position - global_position
	target_offset *= zoom_adjust_percent

#	if tween!=null and tween.is_running():
#		return
#	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self,"global_position",zoom_adjust_percent*map.global_position\
#	+(1-zoom_adjust_percent)*global_position,.2)

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)


# Shake with decreasing intensity while there's time remaining.
func shake_process(delta:float):
	# Only shake when there's shake time remaining.
	if _timer == 0:
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = randf_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = randf_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		camera_2d.set_offset(camera_2d.get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		camera_2d.set_offset(camera_2d.get_offset() - _last_offset)

# Kick off a new screenshake effect.
func shake(duration:float=.3, frequency:int=30, amplitude:int=20):
	if frequency == 0: return
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = randf_range(-1.0, 1.0)
	_previous_y = randf_range(-1.0, 1.0)
	# Reset previous offset, if any.
	camera_2d.set_offset(camera_2d.get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)

