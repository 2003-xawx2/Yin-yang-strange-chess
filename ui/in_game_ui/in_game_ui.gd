extends CanvasLayer





















































#@export var out_place:Container
#@export var in_place:Container
#@export var max_in_place_amounts:int =10
#var in_place_index:int = 0
#var tween_1:Tween
#var tween_2:Tween

#func _ready():
	#get_tree().paused = true
	#var i := 1
	#for child in in_place.get_children():
		#if child.get_child(0) is Label:
			#child.get_child(0).text = str(i)
			#i+=1
#
#
#func move_in(object:CanvasItem)->void:
	#var if_move_in:bool = out_place == object.get_parent().get_parent()
	#if if_move_in and in_place_index == max_in_place_amounts:
		#return
	#
	#var start_position :Vector2 = object.global_position
	#object.get_parent().remove_child(object)
	#if if_move_in:
		#in_place.get_child(in_place_index).add_child(object)
		#in_place_index+=1
		#object.if_in_use = true
		#object.action_press_key = in_place_index
		#object.position = Vector2.ZERO
	#else:
		#out_place.get_child(object.id).add_child(object)
		#object.if_in_use = false
		#object.position = object.reset_position
		#reset_left()
		#in_place_index-=1
	#var end_position:Vector2 = object.global_position
	#object.global_position = start_position
	#tween_1=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	#tween_1.tween_property(object,"global_position",end_position,.5)
#
#
#func reset_left()->void:
	#var empty_index:int
	#for i in range(in_place_index+1):
		#if in_place.get_child(i).get_child_count()==1:
			#empty_index = i
			#break
	#for i in range(empty_index+1,in_place_index):
		##下面的1是个问题
		#var temp:= in_place.get_child(i).get_child(1)
		#temp.action_press_key -=1
		#if temp == null:return
		#var start_position:Vector2 = in_place.get_child(i).global_position
		#in_place.get_child(i).remove_child(temp)
		#in_place.get_child(i-1).add_child(temp)
		#var end_position:Vector2 = in_place.get_child(i-1).global_position
		#temp.global_position = start_position
		#tween_2=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		#tween_2.tween_property(temp,"global_position",end_position,.3)



