extends Area2D

@export var parent:Node2D

func _process(delta):
	if !parent.attracted_to and parent.if_has_settle_place:
		update_status()


func _on_settle_area_area_entered(area):
	parent.if_has_settle_place = true


func update_status()->void:
	var settle_areas:=get_tree().get_nodes_in_group("base")
	for settle_area in settle_areas:
		change_modulate(settle_area,1)
	change_modulate(parent.settle_place,.4)


func _on_settle_area_area_exited(area):
	change_modulate(area.get_parent(),1)
	if $SettleArea.get_overlapping_areas().size()==0:
		parent.if_has_settle_place = false
		return


func change_modulate(object:Node2D,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


func free_self()->void:
	#change_modulate(parent.settle_place,1)
	change_modulate(parent,0)
	await get_tree().create_timer(.8).timeout
	parent.queue_free()


func try_to_settle()->void:
	modulate.a = .5


func settle_fail()->void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"modulate:a",0,.3).from(.6)
	#await tween.finished
	change_modulate(parent.settle_place,1)
	free_self()


func settle_success()->void:
	parent.global_position = parent.settle_place.human_reset_position
	#settle_place.add_child(self)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"modulate:a",1,.3).from(.6)
	change_modulate(parent.settle_place,1)
	parent.attracted_to = true
	#scale = Vector2.ONE*1.0/9
	parent.settle_place.set_unavailable()
	parent.settle_place.human = self
