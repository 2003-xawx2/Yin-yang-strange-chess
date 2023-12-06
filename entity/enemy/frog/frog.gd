extends CharacterBody2D
class_name frog

enum State{
	PATH_FOLLOWING,
	WALKING,
	FIGHTING,
}

@export var Ying_Modulate:Color
@export var Yang_Modulate:Color
@export var Human_Modulate:Color
@export var jump_speed :float = 200
@export var acceleration :float = 100
@export_category("attack")
@export var first_attack_time:float=.8
@export var attack_interval:float=1.8

@onready var frider____1_ = $"frider 无脚(1)"
@onready var recover_timer = $Timer/RecoverTimer
@onready var affected_timer = $Timer/AffectedTimer
@onready var enemy_move_better = $EnemyMoveBetter
@onready var health_bar = $HealthBar
@onready var hit_area = $HitBox
@onready var hurt_area = $HurtBox
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $Timer/AttackTimer
@onready var detect_area = $DetectArea
@onready var attack_range:float = 700
@onready var navigation_agent_2d = $NavigationAgent2D

var stop_frames:int:
	set(value):
		$machine_state.stop_frames = stop_frames
	get:
		return $machine_state.stop_frames
#阵营
var faction:Global.Faction:
	set(value):
		if value == Global.Faction.Ying:
			frider____1_.material.set_shader_parameter("modulate",Ying_Modulate)
			modulate = Ying_Modulate
			hit_area.set_collision_mask_value(4,false)
			hit_area.set_collision_mask_value(5,true)
			hurt_area.set_collision_layer_value(4,true)
			hurt_area.set_collision_layer_value(5,false)
		elif value == Global.Faction.Yang:
			frider____1_.material.set_shader_parameter("modulate",Yang_Modulate)
			modulate = Yang_Modulate
			hit_area.set_collision_mask_value(5,false)
			hit_area.set_collision_mask_value(4,true)
			hurt_area.set_collision_layer_value(5,true)
			hurt_area.set_collision_layer_value(4,false)
		else:
			frider____1_.material.set_shader_parameter("modulate",Human_Modulate)
			modulate = Human_Modulate
			hit_area.set_collision_mask_value(5,true)
			hit_area.set_collision_mask_value(4,true)
			hurt_area.set_collision_layer_value(5,true)
			hurt_area.set_collision_layer_value(4,true)
			affected_timer.start(10)
		faction = value

var jumping:bool = false
var died:=false
var speed:float = 0
var target_position:Vector2 = Vector2.ZERO
var spawn_position :Vector2
var enemies:Array[Node2D]
var detect_enemy:Node2D = null
var target_global_position:Vector2


func _ready():
	health_bar.value = health_bar.max_value
	set_alpha(.6)


#每个状态的的行为模式
func take_physics(state: State, delta: float) -> void:
	if died:return
	update_detect_enemy()
	match state:
		State.PATH_FOLLOWING:
			follow_path(delta)
			
		State.WALKING:
			move(delta)
		
		State.FIGHTING:
			fight(delta)

#获取下一个状态
func get_next_state(state: State) -> State:
	match state:
		State.PATH_FOLLOWING:
			if detect_enemy != null:
				return State.WALKING
		State.WALKING:
			if detect_enemy == null:
				return State.PATH_FOLLOWING
			if detect_enemy.global_position.distance_squared_to(global_position)<=pow(attack_range,2):
				return State.FIGHTING
		State.FIGHTING:
#			update_detect_enemy()
			if detect_enemy == null:
				if recover_timer.is_stopped():
					recover_timer.start()
				elif recover_timer.time_left < 1:
					recover_timer.stop()
					return State.PATH_FOLLOWING
			elif $machine_state.state_time>attack_interval:
				if detect_enemy.global_position.distance_squared_to(global_position)>pow(attack_range,2):
					return State.WALKING
	return state

#状态转换（动画，timer）
func transition_state(from: State, to: State) -> void:
	if from == to or died: return
#	else:
#		print("%s\t->%s" % [State.keys()[from], State.keys()[to]])
	if from == State.FIGHTING:
		attack_timer.stop()
	match to:
		State.PATH_FOLLOWING:
			if_visible(false,1.5)
			navigation_agent_2d.target_position = target_global_position
			animation_player.queue("walk")
		State.WALKING:
			if detect_enemy == null:
				return
			if_visible(false,1.5)
			navigation_agent_2d.target_position = detect_enemy.global_position
			animation_player.queue("walk")
		State.FIGHTING:
			animation_player.play("ready")
			if_visible(true,.5)
			_on_attack_timer_timeout()
			attack_timer.start(first_attack_time)


func follow_path(delta:float)->void:
	navigation_agent_2d.target_position = target_global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = enemy_move_better.update_colliding()
	direction  = direction + unwilling_direction
	if jumping:
		velocity = velocity.lerp(direction.normalized()*jump_speed, 1-exp(-delta*acceleration*2.0))
	else:
		velocity = velocity.lerp(Vector2.ZERO,1-exp(-delta * acceleration * 2.0))
	move_and_slide()
	if velocity.x >=50:
		frider____1_.flip_h = true
	elif velocity.x <=-50:
		frider____1_.flip_h = false


func move(delta:float)->void:
	if detect_enemy == null:return
	navigation_agent_2d.target_position = detect_enemy.global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = enemy_move_better.update_colliding()
	direction  = direction + unwilling_direction
	if jumping:
		velocity = velocity.lerp(direction.normalized()*jump_speed, 1-exp(-delta*acceleration*2.0))
		if $machine_state.state_time>.26 &&velocity.length()<10:
			velocity = velocity.rotated(delta*10)
	else:
		velocity = velocity.lerp(Vector2.ZERO,1-exp(-delta * acceleration * 2.0))
	move_and_slide()
	if velocity.x >=50:
		frider____1_.flip_h = true
	elif velocity.x <=-50:
		frider____1_.flip_h = false


func fight(delta:float)->void:
	var direction:Vector2 = target_position-global_position
	if jumping:
		velocity = velocity.lerp(direction.normalized()*jump_speed*4, 1-exp(-delta*acceleration*4.0))
	else:
		velocity = velocity.lerp(Vector2.ZERO,1-exp(-delta*acceleration/2))
	move_and_slide()
	
	if detect_enemy == null:
		return
	
	if (detect_enemy.global_position - global_position).dot(Vector2.RIGHT)>0:
		frider____1_.flip_h = true
	else:
		frider____1_.flip_h = false


func _on_health_bar_die()->void:
	died = true
	free_self()


func arrive_path_end()->void:
	free_self()


func free_self()->void:
	died = true
	attack_timer.stop()
	animation_player.play("die")
	await animation_player.animation_finished
	queue_free()


func update_detect_enemy():
	if detect_enemy!=null and detect_enemy.faction != faction:
		return
	enemies = detect_area.get_overlapping_bodies()
	enemies = enemies.filter(_filter_faction)
	if enemies.size()==0:
		detect_enemy = null
		return
	else:
		#柿子捡软的捏
		var easy_enemies = enemies.filter(_filter_easy)
		if easy_enemies.size()!=0:
			enemies = easy_enemies
		
		var distance : float = enemies[0].global_position.distance_squared_to(global_position)
		var min_distance: float = distance
		detect_enemy = enemies[0]
		for enemy in enemies:
			if enemy == enemies[0]:
				continue
			else:
				distance = enemy.global_position.distance_squared_to(global_position)
				if distance < min_distance:
					min_distance = distance
					detect_enemy = enemy


func _filter_faction(enemy:Node2D)->bool:
	if enemy == null:
		return false
	if !enemy is CharacterBody2D:
		return false
	if enemy.faction == faction:
		return false
	return true


func _filter_easy(enemy:Node2D)->bool:
	if enemy is maggot:
		return true
	return false


func _on_attack_timer_timeout():
	if detect_enemy == null:
		return
	target_position = detect_enemy.global_position
	animation_player.play("attack")
	attack_timer.start(attack_interval)


func _on_detect_area_body_entered(body):
	#enemies.push_back(body)
	pass


func _on_detect_area_body_exited(body):
	#if enemies.find(body)!=-1:
		#enemies.erase(body)
	pass


func set_jumping_mode(flag :bool)->void:
	jumping = flag


var tween:Tween
func if_visible(flag:bool,time:float)->void:
	$CollisionShape2D.disabled = !flag
	if tween!=null && tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN)
	var percent:float = 0.6 if flag == false else 0
	tween.tween_method(set_alpha,get_alpha(),float(percent),time)


func set_alpha(percent:float)->void:
	frider____1_.material.set_shader_parameter("alpha",percent)
	health_bar.modulate.a=1-percent


func get_alpha()->float:
	return frider____1_.material.get_shader_parameter("alpha")


func _on_affected_timer_timeout():
	faction = randi_range(1,2)
