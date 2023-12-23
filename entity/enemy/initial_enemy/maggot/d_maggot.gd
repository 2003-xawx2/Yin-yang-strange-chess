extends basic_enemy
class_name maggot

@onready var hurt_collision: CollisionShape2D = $Area/HurtBox/CollisionShape2D


func _ready() -> void:
	animation.play("walk")


func transition_state(from: State, to: State) -> void:
	super(from,to)
	if from == to or died: return
	if from == State.FIGHTING:
		animation.play_backwards("attack")
	match to:
		State.PATH_FOLLOWING:
			animation.queue("walk")
		State.WALKING:
			animation.queue("walk")
		State.FIGHTING:
			rotation = 0
			animation.play("ready")
			attack_timer.start(first_attack_time)


func track_attack_target()->void:
	if detect_enemy == null:
		return
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
	attack_timer.start(attack_interval)


func free_self()->void:
	super()
	animation.play("die")
