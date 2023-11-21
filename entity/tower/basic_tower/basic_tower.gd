extends StaticBody2D


@export var bullet_speed :float = 2000
@export var damage:float=2
@export var fire_time:float=2
@export var rotate_acceleration:float=3


@onready var basic_bullet_scence :PackedScene= preload("res://entity/tower/basic_tower/basic_bullet.tscn")
@onready var tower_sprite = $TowerImage
@onready var bullet_timer = $BulletTimer
@onready var bullet_spawn_position = $TowerImage/BulletSpawnPosition


var target:CharacterBody2D
var enemies:Array[CharacterBody2D]


func _ready()->void:
	bullet_timer.wait_time = fire_time


func _process(delta):
	var target_rotation :float= 0
	if target != null:
		target_rotation = (target.global_position - global_position).angle()
	rotation = lerp(rotation , target_rotation , 1-exp(-delta*rotate_acceleration))


func _on_detect_area_body_entered(body:CharacterBody2D):
	if body.is_in_group("enemy"):
		enemies.push_back(body)
	target = return_far_target()
	change_timer_state()
#	print(enemies)


func _on_detect_area_body_exited(body:CharacterBody2D):
	if body.is_in_group("enemy"):
		enemies.pop_front()
	target = return_far_target()
	change_timer_state()


func return_far_target()->CharacterBody2D:
	var temp_target:CharacterBody2D = null
	var max_distance:float = 0
	for enemy in enemies:
		if enemy == null:
			continue
		var distance = enemy.get_progress_ratio()
#		var distance = enemy.global_position.distance_squared_to(global_position)
		if distance > max_distance:
			temp_target = enemy
			max_distance = distance
	return temp_target


func change_timer_state()->void:
	if target == null:
		bullet_timer.stop()
	else:
		if bullet_timer.is_stopped():
			bullet_timer.start()


func _on_bullet_timer_timeout():
	fire_bullet()


func fire_bullet()->void:
	var bullet_instance = basic_bullet_scence.instantiate()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = bullet_spawn_position.global_position
	bullet_instance.start(Vector2.RIGHT.rotated(rotation),bullet_speed,damage)
