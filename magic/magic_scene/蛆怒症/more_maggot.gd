extends Node2D

var maggot_scene:=preload("res://entity/enemy/maggot/maggot.tscn")
@export var except_range:float = 228

func _ready():
	#$"攻击范围2".modulate.a=0
	#change_modulate($"攻击范围2",1)
	pass


func try_to_settle()->void:
	pass


func settle_success()->void:
	var enemies:Array = $DetectArea.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	for enemy in enemies:
		copy_maggot(enemy)
	#change_modulate($"攻击范围2",0)
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	queue_free()


func copy_maggot(copy:maggot)->void:
	var maggot_instance=  maggot_scene.instantiate()
	copy.get_parent().add_child(maggot_instance)
	maggot_instance.spawn_position = copy.spawn_position
	maggot_instance.target_global_position = copy.target_global_position+Vector2.UP*30
	maggot_instance.faction = copy.faction
	maggot_instance.global_position = copy.global_position


func _filter(enemy)->bool:
	if enemy is maggot:
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
