extends StaticBody2D


@export var bullet_speed :float = 2000
@export var damage:float=2
@export var fire_time:float=2
@export var rotate_acceleration:float=3


@onready var basic_bullet_scence :PackedScene= preload("res://entity/tower/basic_tower/basic_bullet.tscn")
@onready var tower_sprite = $TowerImage
@onready var bullet_timer = $BulletTimer
@onready var bullet_spawn_position = $TowerImage/BulletSpawnPosition
@onready var detect_area = $DetectArea


var if_has_settle_place:bool = false
var settle_place:Node2D
var attracted_to:bool = false:
	set(value):
		attracted_to = value
		remove_child.call_deferred($SettleArea)
		var tween:Tween = create_tween()
		tween.tween_property($Panel,"modulate:a",0,.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		remove_child($Panel)
var target:CharacterBody2D
var enemies:Array[Node2D]


func _ready()->void:
	bullet_timer.wait_time = fire_time

 
func _process(delta):
	if !attracted_to and if_has_settle_place:
		update_status()
	else:
		var target_rotation : float= 0
		target = return_far_target()
		if target != null:
			target_rotation = (target.global_position - global_position).angle()
		if target_rotation == 0:
			bullet_timer.stop()
		rotation = lerp_angle(rotation , target_rotation , 1-exp(-delta*rotate_acceleration))


func _on_detect_area_body_entered(body:CharacterBody2D):
	enemies = detect_area.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	change_timer_state()


func _on_detect_area_body_exited(body:CharacterBody2D):
	enemies = detect_area.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	change_timer_state()


func return_far_target()->CharacterBody2D:
	var temp_target:CharacterBody2D = null
	var max_distance:float = 0
	for enemy in enemies:
		if enemy == null:
			continue
#		var distance = enemy.get_progress_ratio()
		var distance = enemy.global_position.distance_squared_to(global_position)
		if distance > max_distance:
			temp_target = enemy
			max_distance = distance
	return temp_target


func change_timer_state()->void:
	if enemies.size()==0:
		bullet_timer.stop()
	else:
		if bullet_timer.is_stopped():
			bullet_timer.start()


func _on_bullet_timer_timeout():
	fire_bullet()
	bullet_timer.start(2+randf_range(-0.4,0.4))


func fire_bullet()->void:
	if !attracted_to: return
	var bullet_instance = basic_bullet_scence.instantiate()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = bullet_spawn_position.global_position
	bullet_instance.start(Vector2.RIGHT.rotated(rotation),bullet_speed,damage)


func _filter(enemy:Node2D)->bool:
	if enemy.is_in_group("enemy"):
		return true
	return false


func set_g_position(_g_position:Vector2)->void:
	global_position = _g_position


func _on_settle_area_area_entered(area):
	if_has_settle_place = true


func update_status()->void:
	var settle_areas:=get_tree().get_nodes_in_group("tower_container")
	settle_place = return_nearest_tower_container(settle_areas)
	change_modulate(settle_place,.4)
	for settle_area in settle_areas:
		if settle_area!=settle_place:
			change_modulate(settle_area,1)


func _on_settle_area_area_exited(area):
	change_modulate(area.get_parent(),1)
	if $SettleArea.get_overlapping_areas().size()==0:
		if_has_settle_place = false
		return


func return_nearest_tower_container(containers:Array)->Node2D:
	if containers.size()==0:
		return null
	var min_distance_s:float=(containers[0].global_position-global_position).length_squared()
	var nearest_container:Node2D=containers[0]
	for container in containers:
		if container == containers[0]:
			continue
		var distance :float= (container.global_position-global_position).length_squared()
		if distance < min_distance_s:
			min_distance_s=distance
			nearest_container=container
	return nearest_container


func change_modulate(object:Node2D,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


func free_self()->void:
	change_modulate(settle_place,1)
	queue_free()
