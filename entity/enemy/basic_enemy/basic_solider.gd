extends CharacterBody2D

enum State{
	PATH_FOLLOWING,
	WALKING,
	FIGHTING,
	BACK_PATH,
}

@export var max_speed :float = 1000
@export var acceleration :float = 300

@onready var path :PathFollow2D = get_parent()
@onready var health_bar = $HealthBar


var speed:float = 0
var direction:Vector2 = Vector2.ZERO


func _ready():
	health_bar.value = health_bar.max_value

#每个状态的的行为模式
func take_physics(state: State, delta: float) -> void:
	match state:
		State.PATH_FOLLOWING:
			follow_path(delta)
			
		State.WALKING:
			move(delta)
		
		State.FIGHTING:
			stand(delta)
		
		State.BACK_PATH:
			move(delta)

#获取下一个状态
func get_next_state(state: State) -> State:
	match state:
		State.PATH_FOLLOWING:
			pass
		State.WALKING:
			pass
		State.FIGHTING:
			pass
		State.BACK_PATH:
			pass
	return State.PATH_FOLLOWING

#状态转换（动画，timer）
func transition_state(from: State, to: State) -> void:
	match to:
		State.PATH_FOLLOWING:
			pass
		State.WALKING:
			pass
		State.FIGHTING:
			pass
		State.BACK_PATH:
			pass


#func _process(delta):
#	if path.progress_ratio == 1:
#		arrive_path_end()


func follow_path(delta:float)->void:
	if speed <max_speed:
		speed += delta*acceleration
	path.set_progress(path.progress+speed*delta)


func move(delta:float)->void:
	velocity = velocity.lerp(direction*max_speed , 1-exp(-delta*acceleration))
	move_and_slide()


func stand(delta:float)->void:
	velocity = velocity.lerp(direction*max_speed , 1-exp(-delta*acceleration))
	move_and_slide()


func _on_health_bar_die()->void:
	queue_free()


func arrive_path_end()->void:
	queue_free()


func get_progress_ratio()->float:
	return path.progress_ratio
