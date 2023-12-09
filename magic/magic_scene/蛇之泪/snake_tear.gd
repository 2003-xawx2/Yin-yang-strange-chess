extends Node2D




func _ready():
	change_modulate($Panel,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate($Panel,0)
	$AnimationPlayer.play("attack!")
	await $AnimationPlayer.animation_finished
	queue_free()


func infect()->void:
	var snakes:Array = $DetectArea.get_overlapping_bodies()
	snakes = snakes.filter(_filter)
	for enemy in snakes:
		enemy.infected = true


func settle_fail()->void:
	pass


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


#func settle_success()->void:
	#var enemies:Array = $Area2D.get_overlapping_bodies()
	#enemies = enemies.filter(_filter)
	#for enemy in enemies:
		#enemy.infected = true
	#change_modulate($"攻击范围2",0)
	#$AnimationPlayer.play("attack!")
	#await $AnimationPlayer.animation_finished
	#queue_free()
#
#
func _filter(enemy)->bool:
	if enemy is snake:
		return true
	else:
		return false
