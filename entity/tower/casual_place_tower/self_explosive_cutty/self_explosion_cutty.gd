extends Node2D

@export var number_of_turns := 1
@export var initial_radius:= 400

@onready var animation_player: AnimationPlayer = $Graphic/AnimationPlayer
@onready var graphic: Node2D = $Graphic
@onready var detect_area: Area2D = $DetectArea

var if_has_settle_place = true
var a_tween :Tween
var target:CharacterBody2D

var rotate_accel
var rotate_speed = .5
var degree:float= 0
var circle_center:Vector2
var radius:Vector2
var radius_length:float

var degrees_at_all
var enemy_position

func _ready() -> void:
	modulate.a = 0
	set_process(false)
	initial_radius = randi_range(500,initial_radius*2-500)
	radius_length = initial_radius
	degrees_at_all = number_of_turns * 2*PI
	rotate_accel = randi_range(0,1)
	if rotate_accel == 0:
		rotate_accel = -1


func try_to_settle()->void:
	change_a(.3)


func settle_fail()->void:
	change_a(0)
	a_tween.tween_callback(queue_free)


func settle_success()->void:
	change_a(1)
	var enemies = detect_area.get_overlapping_bodies()
	enemies = enemies.filter(func(enemy)->bool:
		if enemy.is_in_group("enemy") and (enemy is snake or enemy is frog or enemy is maggot):
			return true
		else:
			return false)
	
	if enemies.size() == 0:
		settle_fail()
		return
	
	enemies.sort_custom(func(a:CharacterBody2D,b:CharacterBody2D)->bool:
		if a.global_position.distance_squared_to(global_position)<\
		b.global_position.distance_squared_to(global_position):
			return true
		return false)
	
	target = enemies[0]
	var temp := (global_position - target.global_position).normalized()
	circle_center = temp * initial_radius+global_position
	radius = - temp * initial_radius
	enemy_position = target.global_position
	set_process(true)


func change_a(a:float)->void:
	if a_tween and a_tween.is_running():
		a_tween.kill()
	a_tween = create_tween().set_ease(Tween.EASE_OUT)
	a_tween.tween_property(self,"modulate:a",a,.6)


var if_hit: = false
func _process(delta: float) -> void:
	if target!=null:
		enemy_position = target.global_position
	
	if if_hit:
		rotate_accel -= delta*2
	
	else:
		rotate_speed += delta * rotate_accel
	var delta_move = delta * rotate_speed
	degree += delta_move
	radius = radius.rotated(delta_move)
	delta_move = abs(delta_move)
	
	var enemy_length:=circle_center.distance_to(enemy_position)
	radius_length = radius.length()
	var delta_length = (enemy_length - radius_length)/((degrees_at_all-degree)/delta_move)
	radius = radius/radius_length
	radius_length += delta_length
	radius *= radius_length
	
	global_position = circle_center + radius
	
	if radius.dot(Vector2.RIGHT)>0:
		graphic.scale.x = -1
	else:
		graphic.scale.x = 1
	
	if degrees_at_all - abs(degree) < .8 and !if_hit:
		if_hit = true
		explosive()
		#rotate_speed/=1.5


func explosive()->void:
	animation_player.play("explosive")
	await animation_player.animation_finished
	set_process(false)
	await get_tree().create_timer(1).timeout
	queue_free()

