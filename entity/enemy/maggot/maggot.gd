extends CharacterBody2D
class_name maggot

enum State{
	PATH_FOLLOWING,
	WALKING,
	FIGHTING,
}

@export var max_speed :float = 250
@export var acceleration :float = 500
@export_category("attack")
@export var first_attack_time:float= .3
@export var attack_interval:float= 2

@onready var health_bar = $HealthBar
@onready var hit_area = $HitBox
@onready var hurt_area = $HurtBox
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $Timer/AttackTimer
@onready var detect_area = $DetectArea
@onready var navigation_agent_2d = $NavigationAgent2D
var attack_range:float = 70

#阵营
var faction:Global.Faction:
	set(value):
		if value == Global.Faction.Ying:
			modulate = Color.BLACK
			hit_area.set_collision_mask_value(4,false)
			hit_area.set_collision_mask_value(5,true)
			hurt_area.set_collision_layer_value(4,true)
			hurt_area.set_collision_layer_value(5,false)
		else:
			modulate = Color.WHITE
			hit_area.set_collision_mask_value(5,false)
			hit_area.set_collision_mask_value(4,true)
			hurt_area.set_collision_layer_value(5,true)
			hurt_area.set_collision_layer_value(4,false)
		faction = value

var died:=false
var speed:float = 0
var target_position:Vector2 = Vector2.ZERO
var enemies:Array[Node2D]
var detect_enemy:Node2D = null
var target_global_position:Vector2


func _ready():
	health_bar.value = health_bar.max_value


func  _physics_process(delta):
	update_detect_enemy()
	if velocity.x>5:
		$MaggotSprite.flip_h = true
	elif velocity.x<=5:
		$MaggotSprite.flip_h = false

#每个状态的的行为模式
func take_physics(state: State, delta: float) -> void:
	match state:
		State.PATH_FOLLOWING:
			look_at(global_position+velocity)
			follow_path(delta)
			
		State.WALKING:
			look_at(global_position+velocity)
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
			if detect_enemy.global_position.distance_squared_to(global_position)<=pow(attack_range,2):
				return State.FIGHTING
		State.FIGHTING:
#			update_detect_enemy()
			if detect_enemy == null:
				attack_timer.stop()
				return State.PATH_FOLLOWING
			if $machine_state.state_time>attack_interval:
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
#			navigation_agent_2d.target_position = target_global_position
			animation_player.queue("walk")
		State.WALKING:
#			navigation_agent_2d.target_position = detect_enemy.global_position
			animation_player.queue("walk")
		State.FIGHTING:
			rotation = 0
			$AnimationPlayer.play("ready_attack")
			attack_timer.start(first_attack_time)


func follow_path(delta:float)->void:
	navigation_agent_2d.target_position = target_global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	velocity = velocity.lerp(direction.normalized()*max_speed, 1-exp(-delta*acceleration))
	move_and_slide()


func move(delta:float)->void:
	navigation_agent_2d.target_position = detect_enemy.global_position
	var direction:Vector2 = navigation_agent_2d.get_next_path_position()-global_position
	velocity = velocity.lerp(direction.normalized()*max_speed, 1-exp(-delta*acceleration))
	if $machine_state.state_time>.2&&velocity.length()<10:
		velocity = velocity.rotated(delta*20)
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
	call_deferred("queue_free")


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
	if detect_enemy == null:
		return
	animation_player.play("attack")
	attack_timer.start(attack_interval)


func track_attack_target()->void:
	if detect_enemy == null:
		return
	$HurtBox/CollisionShape2D.global_position = detect_enemy.global_position


func _on_detect_area_body_entered(body):
	enemies.push_back(body)


func _on_detect_area_body_exited(body):
	if enemies.find(body)!=-1:
		enemies.erase(body)
