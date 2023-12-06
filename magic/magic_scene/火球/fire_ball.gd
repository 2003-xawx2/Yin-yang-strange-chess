extends Node2D

@export var detect_range:=200

func _ready():
	change_modulate($Panel,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate($Panel,0)
	
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	queue_free()



func settle_fail()->void:
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"modulate:a",0,.5)
	change_modulate($Panel,0)
	await tween.finished
	queue_free()


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)

