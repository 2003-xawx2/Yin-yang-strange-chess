extends CharacterBody2D
class_name maggot

enum State{
	PATH_FOLLOWING,
	WALKING,
	FIGHTING,
}


@export var Ying_Modulate:Color
@export var Yang_Modulate:Color
@export var Human_Modulate:Color
@export var max_speed :float = 250
@export var acceleration :float = 500
@export_category("attack")
@export var first_attack_time:float= .3
@export var attack_interval:float= 2

@onready var affect_timer = $Timer/AffectTimer
@onready var maggot____ = $"maggot 的副本"
@onready var enemy_move_better = $EnemyMoveBetter
@onready var health_bar = $HealthBar
@onready var hit_area = $HitBox
@onready var hurt_area = $HurtBox
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $Timer/AttackTimer
@onready var detect_area = $DetectArea
@onready var navigation_agent_2d = $NavigationAgent2D
var attack_range:float = 120
var stop_frames:int:
	set(value):
		$machine_state.stop_frames = stop_frames
	get:
		return $machine_state.stop_frames
#阵营
var faction:Global.Faction:
	set(value):
		if value == Global.Faction.Ying:
			modulate = Ying_Modulate
			hit_area.set_collision_mask_value(4,false)
			hit_area.set_collision_mask_value(5,true)
			hurt_area.set_collision_layer_value(4,true)
			hurt_area.set_collision_layer_value(5,false)
		elif value == Global.Faction.Yang:
			modulate = Yang_Modulate
			hit_area.set_collision_mask_value(5,false)
			hit_area.set_collision_mask_value(4,true)
			hurt_area.set_collision_layer_value(5,true)
			hurt_area.set_collision_layer_value(4,false)
		else:
			modulate = Human_Modulate
			hit_area.set_collision_mask_value(5,true)
			hit_area.set_collision_mask_value(4,true)
			hurt_area.set_collision_layer_value(5,true)
			hurt_area.set_collision_layer_value(4,true)
			affect_timer.start(10)
		faction = value

var spawn_position:Vector2 = Vector2.ZERO
var died:=false
var speed:float = 0
var target_position:Vector2 = Vector2.ZERO
var enemies:Array[Node2D]
var detect_enemy:Node2D = null
var target_global_position:Vector2
var target_rotation :float


func _ready():
	health_bar.value = health_bar.max_value


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
			stand(delta)

#获取下一个状态
func get_next_state(state: State) -> State:
	match state:
		State.PATH_FOLLOWING:
			if detect_enemy != null:
				return State.WALKING
		State.WALKING:
			if detect_enemy == null:
				return State.PATH_FOLLOWING
			if $machine_state.state_time>.5 and velocity.length()<50:
				return State.FIGHTING
			if detect_enemy.global_position.distance_squared_to(global_position)<=pow(attack_range,2):
				return State.FIGHTING
		State.FIGHTING:
#			update_detect_enemy()
			if detect_enemy == null:
				attack_timer.stop()
				return State.PATH_FOLLOWING
			if $machine_state.state_time>attack_interval+first_attack_time:
				if detect_enemy.global_position.distance_squared_to(global_position)>pow(attack_range,2):
					attack_timer.stop()
					return State.WALKING
	return state

#状态转换（动画，timer）
func transition_state(from: State, to: State) -> void:
	if from == to or died: return
#	else:
#		print("%s\t->%s" % [State.keys()[from], State.keys()[to]])
	else:
		$Label.text = State.keys()[to]
	if from == State.FIGHTING:
		$AnimationPlayer.play_backwards("ready")
	match to:
		State.PATH_FOLLOWING:
#			navigation_agent_2d.target_position = target_global_position
			animation_player.queue("walk")
		State.WALKING:
#			navigation_agent_2d.target_position = detect_enemy.global_position
			animation_player.queue("walk")
		State.FIGHTING:
			rotation = 0
			$AnimationPlayer.play("ready")
			attack_timer.start(first_attack_time)


func follow_path(delta:float)->void:
	navigation_agent_2d.target_position = target_global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = enemy_move_better.update_colliding()
	direction = direction+unwilling_direction
	if maggot____.scale.x>0:
		target_rotation  = lerp_angle(target_rotation,direction.angle(),1-exp(-delta))
	else:
		target_rotation  = lerp_angle(target_rotation,(-direction).angle(),1-exp(-delta))
	target_rotation = clamp(target_rotation,-PI/6,PI/6)
	maggot____.rotation = target_rotation
	velocity = velocity.lerp(direction.normalized()*max_speed, 1-exp(-delta*acceleration))
	move_and_slide()

	if velocity.x>50:
		maggot____.scale.x = 2
	elif velocity.x<=-50:
		maggot____.scale.x = -2


func move(delta:float)->void:
	if detect_enemy == null:
		return
	navigation_agent_2d.target_position = detect_enemy.global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = enemy_move_better.update_colliding()
	direction = direction+unwilling_direction.rotated(PI/3)
	target_rotation  = lerp_angle(target_rotation,direction.angle(),1-exp(-delta))
	target_rotation = clamp(target_rotation,-PI/6,PI/6)
	maggot____.rotation = target_rotation
	velocity = velocity.lerp(direction.normalized()*max_speed, 1-exp(-delta*acceleration))
	rotation = lerp_angle(rotation,float(0),delta)
	move_and_slide()

	if velocity.x>50:
		maggot____.scale.x = 2
	elif velocity.x<=-50:
		maggot____.scale.x = -2


func stand(delta:float)->void:
	target_rotation  = lerp_angle(target_rotation,0,1-exp(-delta))
	maggot____.rotation = target_rotation
	velocity = velocity.lerp( Vector2.ZERO , 1-exp(-delta*acceleration))
	move_and_slide()
	
	if detect_enemy == null:
		return
	
	if (detect_enemy.global_position - global_position).dot(Vector2.RIGHT)>0:
		maggot____.scale.x = 2
	else:
		maggot____.scale.x = -2


func _on_health_bar_die()->void:
	free_self()


func arrive_path_end()->void:
	free_self()


func free_self()->void:
	died = true
	attack_timer.stop()
	animation_player.play("die")


func update_detect_enemy():
	if detect_enemy!=null and detect_enemy.faction != faction:
		return
	enemies = detect_area.get_overlapping_bodies()
	enemies = enemies.filter(_filter_faction)
	if enemies.size()==0:
		detect_enemy = null
		return null
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
	if enemy is snake:
		return true
	return false


func _on_attack_timer_timeout():
	if detect_enemy == null:
		return
	animation_player.play("attack")
	attack_timer.start(attack_interval)


func track_attack_target()->void:
	if detect_enemy == null:
		return
	$HurtBox/CollisionShape2D.global_position = detect_enemy.global_position


func _on_detect_area_body_entered(body):
	#enemies.push_back(body)
	pass


func _on_detect_area_body_exited(body):
	#if enemies.find(body)!=-1:
		#enemies.erase(body)
	pass


func _on_affect_timer_timeout():
	faction = randi_range(1,2)
