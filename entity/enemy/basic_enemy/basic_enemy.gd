extends CharacterBody2D
class_name basic_enemy

@onready var enemy_sprite: Sprite2D = $Graphic/EnemySprite
@onready var graphic: Node2D = $Graphic
@onready var animation: AnimationPlayer = $Graphic/AnimationPlayer
@onready var detect_area: Area2D = $Area/DetectArea
@onready var hit_box: HitBox = $Area/HitBox
@onready var hurt_box: HurtBox = $Area/HurtBox
@onready var affect_timer: Timer = $Component/AffectTimer
@onready var attack_timer: Timer = $Component/AttackTimer
@onready var m_state: machine_state = $Component/_machine_state
@onready var health_manager: HealthManager = $HealthManager
@onready var ngt_agent: NavigationAgent2D = $Component/NavigationAgent2D
@onready var move_better: Node2D = $Component/EnemyMoveBetter
@onready var move_com: Node2D = $Component/MoveComponent

@export var graphic_scale:float = 1
@export var infected_time := 10
@export_category("Modulate")
@export var Ying_Modulate:Color
@export var Yang_Modulate:Color
@export var Human_Modulate:Color
@export_category("attack")
@export var first_attack_time:float= .3
@export var attack_interval:float= 2
@export var attack_range:float = 120

enum State{PATH_FOLLOWING,WALKING,FIGHTING,}

var spawn_position:Vector2 = Vector2.ZERO
var target_position:Vector2 = Vector2.ZERO
var target_global_position:Vector2
var enemies:Array[Node2D]
var detect_enemy:Node2D = null
var died:=false

var stop_frames:int:
	set(value):
		m_state.stop_frames = value
	get:
		return m_state.stop_frames

var pre_faction
var faction:Global.Faction:
	set(value):
		faction_look(value)
		if value == Global.Faction.Ying:
			hit_box.set_collision_mask_value(4,false)
			hit_box.set_collision_mask_value(5,true)
			hurt_box.set_collision_layer_value(4,true)
			hurt_box.set_collision_layer_value(5,false)
		elif value == Global.Faction.Yang:
			hit_box.set_collision_mask_value(5,false)
			hit_box.set_collision_mask_value(4,true)
			hurt_box.set_collision_layer_value(5,true)
			hurt_box.set_collision_layer_value(4,false)
		else:
			hit_box.set_collision_mask_value(5,true)
			hit_box.set_collision_mask_value(4,true)
			hurt_box.set_collision_layer_value(5,true)
			hurt_box.set_collision_layer_value(4,true)
			affect_timer.start(infected_time)
			pre_faction = faction
		faction = value


func faction_look(_faction:Global.Faction):
	match(_faction):
		Global.Faction.Ying:
			modulate = Ying_Modulate
		Global.Faction.Yang:
			modulate = Yang_Modulate
		Global.Faction.Human:
			modulate = Human_Modulate


#每个状态的的行为模式
func take_physics(state: State, delta: float) -> void:
	if died:return
	match state:
		State.PATH_FOLLOWING:
			follow_path(delta)

		State.WALKING:
			move(delta)

		State.FIGHTING:
			stand(delta)

#获取下一个状态
func get_next_state(state: State) -> State:
	update_detect_enemy()
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

			if detect_enemy == null:
				attack_timer.stop()
				return State.PATH_FOLLOWING
			if m_state.state_time>attack_interval+first_attack_time:
				if detect_enemy.global_position.distance_squared_to(global_position)>pow(attack_range,2):
					attack_timer.stop()
					return State.WALKING
	return state

#状态转换（动画，timer）
func transition_state(from: State, to: State) -> void:
	if from == to or died: return
	else:
		$Label.text = State.keys()[to]


func flip_on_velocity()->void:
	if velocity.x>50:
		graphic.scale.x = 1 * graphic_scale
	elif velocity.x<=-50:
		graphic.scale.x = -1 * graphic_scale


#未检测到敌人
func follow_path(delta:float)->void:
	ngt_agent.target_position = target_global_position
	var direction:Vector2 = ngt_agent.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = move_better.update_colliding()
	direction = direction+unwilling_direction
	move_com.accelerate_to_direction(direction,delta)
	flip_on_velocity()


func move(delta:float)->void:
	if detect_enemy == null:
		return
	ngt_agent.target_position = detect_enemy.global_position
	var direction:Vector2 = ngt_agent.get_next_path_position()-global_position
	var unwilling_direction:Vector2 = move_better.update_colliding()
	direction = direction+unwilling_direction/1.5
	move_com.accelerate_to_direction(direction,delta)
	flip_on_velocity()


func stand(delta:float)->void:
	move_com.accelerate_to_direction(Vector2.ZERO,delta)

	if detect_enemy == null:
		return
	flip_on_enemy()


func flip_on_enemy()->void:
	if (detect_enemy.global_position - global_position).dot(Vector2.RIGHT)>0:
		graphic.scale.x = 1 * graphic_scale
	else:
		graphic.scale.x = -1 * graphic_scale


func _on_health_bar_die()->void:
	free_self()


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
	if !enemy.is_in_group("enemy"):
		return false
	if !enemy is CharacterBody2D:
		return false
	if enemy.faction == faction:
		return false
	return true


func _filter_easy(enemy:Node2D)->bool:
	return true


func _on_attack_timer_timeout():
	if detect_enemy == null or died:
		return
	animation.play("attack")
	attack_timer.start(attack_interval)


func free_self()->void:
	died = true
	attack_timer.stop()


func _on_navigation_agent_2d_target_reached() -> void:
	if ngt_agent.target_position == target_global_position:
		Global.arrived.emit()
		free_self()


func _on_affect_timer_timeout() -> void:
	faction = pre_faction
