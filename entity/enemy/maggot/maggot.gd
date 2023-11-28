extends CharacterBody2D
class_name maggot

enum State{
	PATH_FOLLOWING,
	WALKING,
	FIGHTING,
}

@export var max_speed :float = 100
@export var acceleration :float = 100
@export_category("attack")
@export var first_attack_time:float=1
@export var attack_interval:float=2

@onready var health_bar = $HealthBar
@onready var hit_area = $HitArea
@onready var hurt_area = $HurtArea
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $Timer/AttackTimer
@onready var detect_area = $DetectArea
var attack_range:float = 150

#阵营
@export var faction:=Global.Faction.Yang

var died:=false
var speed:float = 0
var direction:Vector2 = Vector2.ZERO
var enemies:Array[Node2D]
var detect_enemy:Node2D = null
var target_global_position:Vector2


func _ready():
	health_bar.value = health_bar.max_value
	if faction == Global.Faction.Ying:
		modulate = Color.BLACK
		hit_area.set_collision_mask_value(4,false)
		hit_area.set_collision_mask_value(5,true)
		hurt_area.set_collision_layer_value(4,true)
		hurt_area.set_collision_layer_value(5,false)
	else:
		modulate = Color.WHITE


func  _physics_process(delta):
	update_detect_enemy()

#每个状态的的行为模式
func take_physics(state: State, delta: float) -> void:
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
			if detect_enemy.global_position.distance_squared_to(global_position)<=pow(attack_range,2):
				return State.FIGHTING
		State.FIGHTING:
#			update_detect_enemy()
			if detect_enemy == null:
				attack_timer.stop()
				return State.WALKING
			if detect_enemy.global_position.distance_squared_to(global_position)>pow(attack_range,2):
				attack_timer.stop()
				return State.WALKING
	return state

#状态转换（动画，timer）
func transition_state(from: State, to: State) -> void:
	if from == to : return
	else:
		print("%s\t->%s" % [State.keys()[from], State.keys()[to]])
	match to:
		State.PATH_FOLLOWING:
			animation_player.queue("walk")
		State.WALKING:
			direction = detect_enemy.global_position - global_position
			animation_player.queue("walk")
		State.FIGHTING:
			attack_timer.start(first_attack_time)


func follow_path(delta:float)->void:
	if speed <max_speed:
		speed += delta*acceleration


func move(delta:float)->void:
	velocity = velocity.lerp(direction.normalized()*max_speed, 1-exp(-delta*acceleration))
	move_and_slide()


func stand(delta:float)->void:
	velocity = velocity.lerp( Vector2.ZERO , 1-exp(-delta*acceleration))
	move_and_slide()


func _on_health_bar_die()->void:
	died = true
	free_self()


func arrive_path_end()->void:
	free_self()


func free_self()->void:
	get_parent().call_deferred("queue_free")


func update_detect_enemy():
	if detect_enemy!= null : return
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
	if enemy.faction == faction:
		return false
	return true


func _filter_easy(enemy:Node2D)->bool:
	if enemy is snake:
		return true
	return false


func _on_attack_timer_timeout():
	$HurtArea/CollisionShape2D.global_position = detect_enemy.global_position
	animation_player.play("attack")
	attack_timer.start(attack_interval)


func _on_detect_area_body_entered(body):
	enemies.push_back(body)


func _on_detect_area_body_exited(body):
	if enemies.find(body)!=-1:
		enemies.erase(body)