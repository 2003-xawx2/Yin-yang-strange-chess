extends Node2D

@export var expense_on_coin:=10
@export var detect_range:=200
@onready var ______ = $"献祭攻击范围"
@onready var hole = $"坑"

func _ready():
	change_modulate(______,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	$RandomAudioPlayer.play_random()
	change_modulate(______,0)
	
	$AnimationPlayer.play("attack!")
	Global.item.collect(dropper.Drop.coin,-expense_on_coin)
	await  $AnimationPlayer.animation_finished
	queue_free()


func give_a_hole()->void:
	remove_child(hole)
	Global.current_world.add_child(hole)
	hole.global_position = ______.global_position
	hole.visible = true


func set_hurt_box()->void:
	$HurtBox/CollisionPolygon2D.disabled = false


func settle_fail()->void:
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"modulate:a",0,.5)
	change_modulate(______,0)
	await tween.finished
	queue_free()


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


func shake()->void:
	Global.camera.get_parent().shake(1,40,70)
