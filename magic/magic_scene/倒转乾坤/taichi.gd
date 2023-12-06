extends Node2D

@export var detect_range:=200

func _ready():
	change_modulate($Panel,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate($Panel,0)
	var enemies :Array = update_enemies()
	for enemy in enemies:
		#enemy = enemy.get_parent()
		if enemy.faction == Global.Faction.Yang:
			enemy.faction = Global.Faction.Ying
		else:
			enemy.faction = Global.Faction.Yang
		var temp:Vector2 = enemy.target_global_position
		enemy.target_global_position = enemy.spawn_position
		enemy.spawn_position = temp
	
	$AnimationPlayer.play("ease_in_out")
	await $AnimationPlayer.animation_finished
	queue_free()


func update_enemies()->Array:
	var enemies:=get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(_filter)
	return enemies


func _filter(enemy)->bool:
	if (enemy.global_position-global_position).length()<detect_range:
		return true
	else:
		return false


func settle_fail()->void:
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"modulate:a",0,.5)
	change_modulate($Panel,0)
	await tween.finished
	queue_free()


func set_para(size_scale:float)->void:
	$ColorRect.material.set_shader_parameter("size_scale",size_scale)


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
