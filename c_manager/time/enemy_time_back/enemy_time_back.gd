extends Node


var time_back:Array[Vector2] = []
var index:int = 0:
	set(value):
		if value == 12:
			index = 0
		else:
			index = value


func _on_timer_timeout():
	if get_parent().faction == Global.Faction.Ying:
		remove_from_group("yang_time_back")
		add_to_group("ying_time_back")
	if get_parent().faction == Global.Faction.Yang:
		remove_from_group("ying_time_back")
		add_to_group("yang_time_back")
	if time_back.size()<12:
		time_back.append(get_parent().global_position)
	else:
		time_back[index] =get_parent().global_position
	index+=1


func load()->void:
	if time_back.size()<12:
		get_parent().global_position = time_back[0]
	else:
		get_parent().global_position = time_back[index]
	get_parent().health_bar.current_health = get_parent().health_bar.max_health
