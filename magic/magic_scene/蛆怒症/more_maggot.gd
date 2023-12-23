extends Node2D

var maggot_scene:=preload("res://entity/enemy/initial_enemy/maggot/d_maggot.tscn")
@export var except_range:float = 228

func _ready():
	#$"攻击范围2".modulate.a=0
	#change_modulate($"攻击范围2",1)
	pass


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate($Panel,0)
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	queue_free()


func copy()->void:
	var enemies:Array = $DetectArea.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	for enemy in enemies:
		copy_maggot(enemy)


func copy_maggot(_copy:maggot)->void:
	if _copy == null:
		return
	var maggot_instance=  maggot_scene.instantiate()
	_copy.get_parent().add_child(maggot_instance)
	maggot_instance.spawn_position = _copy.spawn_position
	maggot_instance.target_global_position = _copy.target_global_position+Vector2.UP*30
	maggot_instance.faction = _copy.faction
	maggot_instance.global_position = _copy.global_position


func _filter(enemy)->bool:
	if enemy is maggot:
		return true
	else:
		return false


func settle_fail()->void:
	change_modulate($Panel,0)
	await get_tree().create_timer(1).timeout
	queue_free()


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)
