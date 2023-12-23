extends basic_enemy
class_name frog

var direction:Vector2
var tween:Tween


func _ready():
	set_alpha(.6)
	animation.play("walk")


func faction_look(_faction:Global.Faction):
	match(_faction):
		Global.Faction.Ying:
			enemy_sprite.material.set_shader_parameter("modulate",Ying_Modulate)
		Global.Faction.Yang:
			enemy_sprite.material.set_shader_parameter("modulate",Yang_Modulate)
		Global.Faction.Human:
			enemy_sprite.material.set_shader_parameter("modulate",Human_Modulate)


func if_visible(flag:bool,time:float)->void:
	await get_tree().create_timer(1).timeout
	$EnemyCollision.disabled = !flag
	if tween!=null && tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN)
	var percent:float = .8 if flag == false else 0
	tween.tween_method(set_alpha,get_alpha(),float(percent),time)


func get_next_state(state: State) -> State:
	if attack_timer.time_left < attack_interval - .5 and !died:
		update_detect_enemy()
		match state:
			State.PATH_FOLLOWING:
				if detect_enemy != null:
					return State.FIGHTING
			State.FIGHTING:
				if detect_enemy == null and m_state.state_time > first_attack_time:
						return State.PATH_FOLLOWING
		return state
	else:
		return state


func transition_state(from: State, to: State) -> void:
	super(from,to)
	if from == to or died: return
#	else:
#		print("%s\t->%s" % [State.keys()[from], State.keys()[to]])
	if from == State.FIGHTING:
		attack_timer.stop()
		move_com.max_speed /= 4
		if animation.current_animation == "attack":
			await animation.animation_finished
		animation.play_backwards("ready")
	match to:
		State.PATH_FOLLOWING:
			if_visible(false,1.5)
			ngt_agent.target_position = target_global_position
			animation.queue("walk")
		State.WALKING:
			if detect_enemy == null:
				return
			if_visible(false,1.5)
			ngt_agent.target_position = detect_enemy.global_position
			animation.queue("walk")
		State.FIGHTING:
			if_visible(true,.5)
			move_com.max_speed *= 4
			if animation.current_animation != "attack":
				animation.play("ready")
			attack_timer.start(first_attack_time)


func stand(delta:float)->void:
	fight(delta)


func fight(delta:float)->void:
	move_com.accelerate_to_direction(direction,delta)


func _on_attack_timer_timeout():
	if detect_enemy == null or died:
		return
	target_position = detect_enemy.global_position
	direction = target_position - global_position
	animation.play("attack")
	flip_on_enemy()
	attack_timer.start(attack_interval)


func set_alpha(percent:float)->void:
	enemy_sprite.material.set_shader_parameter("alpha",percent)
	health_manager.modulate.a=1-percent


func get_alpha()->float:
	return enemy_sprite.material.get_shader_parameter("alpha")


func _filter_easy(enemy:Node2D)->bool:
	if enemy is maggot:
		return true
	return false


func free_self()->void:
	super()
	animation.play("die")


func set_jumping_mode(flag:bool)->void:
	move_com._if_walk = flag
