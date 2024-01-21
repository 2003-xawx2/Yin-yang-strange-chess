extends StaticBody2D
class_name basic_base

@onready var settle_area = $SettleArea

var id:int
var human_reset_position:Vector2
var human:Node2D
var if_has_settle_place:bool = false
var settle_place:Node2D
var attracted_to:bool = false:
	set(value):
		attracted_to = value
		remove_child(settle_area)
	get:
		return attracted_to


func _process(delta):
	if !attracted_to and if_has_settle_place:
		update_status()
	human_reset_position = global_position + $CaptrueArea.position


func _on_settle_area_area_entered(area):
	if_has_settle_place = true


func update_status()->void:
	var settle_areas:=get_tree().get_nodes_in_group("tower_container")
	settle_place = return_nearest_tower_container(settle_areas)
	for _settle_area in settle_areas:
		change_modulate(_settle_area,1)
	change_modulate(settle_place,.4)


func _on_settle_area_area_exited(area):
	change_modulate(area.get_parent(),1)
	if $SettleArea.get_overlapping_areas().size()==0:
		if_has_settle_place = false
		return


func return_nearest_tower_container(containers:Array)->Node2D:
	if containers.size()==0:
		return null
	var min_distance_s:float=(containers[0].global_position-global_position).length_squared()
	var nearest_container:Node2D=containers[0]
	for container in containers:
		if container == containers[0]:
			continue
		var distance :float= (container.global_position-global_position).length_squared()
		if distance < min_distance_s:
			min_distance_s=distance
			nearest_container=container
	return nearest_container


func change_modulate(object:Node2D,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


func free_self()->void:
	change_modulate(settle_place,1)
	if human!=null:
		human.queue_free()
	await get_tree().create_timer(.5).timeout
	queue_free()


func try_to_settle()->void:
	modulate.a = .5


func settle_fail()->void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"modulate:a",0,.3).from(.6)
	free_self()


func settle_success()->void:
	global_position = settle_place.global_position
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"modulate:a",1,.3).from(.6)
	change_modulate(settle_place,1)
	attracted_to = true
	#scale = Vector2.ONE*1.0/9
	settle_place.set_unavailable()
	settle_place.tower = self


func set_unavailable()->void:
	$CaptrueArea/CollisionShape2D.disabled = true


func _on_captrue_area_area_entered(area):
	area.get_parent().settle_place = self
	area.get_parent().if_has_settle_place = true


func _on_captrue_area_area_exited(area):
	area.get_parent().if_has_settle_place = false
	change_modulate(self,1)
