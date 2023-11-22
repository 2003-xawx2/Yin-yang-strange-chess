extends Sprite2D


var tower_body:Node2D =null


func _physics_process(delta):
	if tower_body == null:
		return
	if tower_body.attracted_to == true:
		queue_free()


func _filter(t_c:Node2D)->bool:
	if t_c.tower_body == null:
		return false
	return true


func return_nearest_container(containers:Array)->Sprite2D:
	var min_distance_s:float=1000
	var nearest_container:Sprite2D=null
	for container in containers:
		var distance = container.global_position.distance_squared_to(global_position)
		if distance<min_distance_s:
			min_distance_s=distance
			nearest_container=container
	return nearest_container


func _on_detect_area_area_entered(area):
	var body = area.get_parent() as Node2D
	tower_body = body
	body.if_has_settle_place = true
	body.settle_place = global_position
	
	var tower_containers :Array =get_tree().get_nodes_in_group("tower_container")
	tower_containers.filter(_filter)
	return_nearest_container(tower_containers).change_modulate(.3)


func _on_detect_area_area_exited(area):
	change_modulate(1)
	tower_body = null
	
	var body = area.get_parent() as Node2D
	body.if_has_settle_place = false


func change_modulate(value:float)->void:
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"modulate:a",value,.3)
