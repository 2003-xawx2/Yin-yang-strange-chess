extends Node2D

@export var except_range:float = 228

func _ready():
	$"攻击范围2".modulate.a=0
	change_modulate($"攻击范围2",1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	var enemies:Array = $Area2D.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	for enemy in enemies:
		enemy.infected = true
	change_modulate($"攻击范围2",0)
	$AnimationPlayer.play("attack!")
	await $AnimationPlayer.animation_finished
	queue_free()


func _filter(enemy)->bool:
	if enemy.global_position.distance_squared_to(global_position)<pow(except_range,2):
		return false
	if enemy is snake:
		return true
	else:
		return false


func settle_fail()->void:
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"modulate:a",0,.5)
	change_modulate($"攻击范围2",0)
	await tween.finished
	queue_free()


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
