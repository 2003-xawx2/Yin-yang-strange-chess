extends Node2D

@export var except_range:float = 228
@onready var random_audio_player: random_audio = $RandomAudioPlayer
var strong_shader:ShaderMaterial = preload("res://entity/enemy/initial_enemy/frog/mutation.tres")


func _ready():
	$"攻击范围2".modulate.a=0
	change_modulate($"攻击范围2",1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	random_audio_player.play_random()
	var enemies:Array = $Area2D.get_overlapping_bodies()
	enemies = enemies.filter(_filter)
	for _frog in enemies:
		var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(_frog,"scale",Vector2.ONE*1.4,1)
		_frog.enemy_sprite.material = strong_shader
		_frog.hurt_box.damage*=2
	change_modulate($"攻击范围2",0)
	$AnimationPlayer.play("attack!")
	await $AnimationPlayer.animation_finished
	queue_free()


func _filter(_frog:Node2D)->bool:
	if _frog is frog:
		return true
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
