extends Node2D
class_name basic_human

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var sprite:Sprite2D
@onready var detect_area := $DetectArea
@onready var settle_area := $SettleArea


@export var back_sprite:=preload("res://entity/tower/person_on_base/wind_herald/飞廉风神back.png")
@export var front_sprite:=preload("res://entity/tower/person_on_base/wind_herald/飞廉风神front.png")


var target:Node2D
var id:int
var reset_position:Vector2
var bullet_position:Vector2
var if_has_settle_place:bool = false
var settle_place:Node2D:
	set(value):
		settle_place = value
	get:
		return settle_place
var attracted_to:bool = false:
	set(value):
		attracted_to = value
		remove_child(settle_area)
		var tween :=create_tween()
		tween.tween_property(self,"modulate:a",1,.3)
	get:
		return attracted_to
var enemies:Array[Node2D]
var direction:Vector2


func _ready():
	modulate.a = .4
	sprite.texture = front_sprite
	detect_area.body_entered.connect(_on_detect_area_body_entered)
	detect_area.body_exited.connect(_on_detect_area_body_exited)


func update_direction()->void:
	target = return_target()
	if target!=null:
		direction = (target.global_position - global_position).normalized()
		adjust_direction(direction)


func small_attack()->void:
	pass


func hurt_attack()->void:
	pass


func adjust_direction(_direction:Vector2)->void:
	if _direction.dot(Vector2.RIGHT)>0.1:
		sprite.flip_h = false
		bullet_position = global_position + Vector2(69,-37)
	elif _direction.dot(Vector2.RIGHT)<-0.1:
		sprite.flip_h = true
		bullet_position = global_position + Vector2(-69,-37)
	if _direction.dot(Vector2.UP)>0.1:
		sprite.texture = back_sprite
	elif _direction.dot(Vector2.UP)<-0.1:
		sprite.texture = front_sprite


func return_target()->Node2D:
	var temp_target:CharacterBody2D = null
	var max_distance:float = 0
	for enemy in enemies:
		if enemy == null or !enemy.is_in_group("enemy"):
			continue
#		var distance = enemy.get_progress_ratio()
		var distance = enemy.global_position.distance_squared_to(global_position)
		if distance > max_distance:
			temp_target = enemy
			max_distance = distance
	return temp_target


func free_self()->void:
	queue_free()


func try_to_settle()->void:
	settle_area.try_to_settle()


func settle_success()->void:
	settle_area.settle_success()
	reparent(settle_place,true)


func settle_fail()->void:
	settle_area.settle_fail()


func update_enemies_attack()->void:
	pass


func _on_detect_area_body_entered(body):
	if attracted_to:
		update_enemies_attack()


func _on_detect_area_body_exited(body):
	if attracted_to:
		update_enemies_attack()


func recoil(_len:int = 8)->void:
	reset_position = position
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"position",-direction*_len+reset_position,0.08)
	tween.tween_property(self,"position",reset_position,0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
