extends basic_enemy
class_name snake

@onready var hurt_collision: CollisionShape2D = $Area/HurtBox/CollisionShape2D


var infected:bool = false:
	set(value):
		if value == true:
			faction = Global.Faction.Human
		infected = value
	get:
		return infected


func _ready() -> void:
	affect_timer.timeout.connect(func():infected = false)
	animation.play("walk")


func transition_state(from: State, to: State) -> void:
	super(from,to)
	if from == to or died: return
	match to:
		State.PATH_FOLLOWING:
			animation.queue("walk")
		State.WALKING:
			animation.queue("walk")
		State.FIGHTING:
			rotation = 0
			attack_timer.start(first_attack_time)


func track_attack_target()->void:
	hurt_collision.global_position = detect_enemy.global_position



func _filter_easy(enemy:Node2D)->bool:
	if enemy is frog:
		return true
	return false


func _on_attack_timer_timeout()->void:
	if detect_enemy == null or died:
		return
	track_attack_target()
	animation.play("attack")
	if infected: detect_enemy.faction = Global.Faction.Human
	attack_timer.start(attack_interval)


func free_self()->void:
	super()
	animation.play("die")


func set_walking(flag:bool)->void:
	move_com._if_walk = flag
