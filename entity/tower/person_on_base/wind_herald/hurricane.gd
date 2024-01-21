extends StaticBody2D

@export var speed = 300.0
var direction:Vector2 = Vector2.ZERO
var line_position:Vector2=Vector2.ZERO
var initial_radius:float
var rotate_position:Vector2
var rotate_mul: = 400


func _ready():
	set_physics_process(false)
	scale = Vector2.ZERO
	line_position = Vector2.ZERO
	initial_radius = 10
	rotate_position = Vector2.UP*initial_radius


func init(_direction):
	line_position = position
	direction = _direction
	if direction.dot(Vector2.UP)>0:
		z_index = -1
	set_physics_process(true)
	var tween:=create_tween()
	tween.tween_property(self,"scale",Vector2.ONE,.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_interval(2)
	tween.tween_property(self,"scale",Vector2.ZERO,3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)
	$Sprite2D.flip_h = sign(direction.x)
	await get_tree().create_timer(.2).timeout
	z_index = 0


func _physics_process(delta):
	#position+=direction.normalized()*speed*delta
	var last_radius := initial_radius
	initial_radius += delta*10
	speed -= delta*4
	line_position+=delta*direction.normalized()*speed
	rotate_position = rotate_position/last_radius*initial_radius
	rotate_position = rotate_position.rotated(delta*rotate_mul/initial_radius)

	position = line_position + rotate_position


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

