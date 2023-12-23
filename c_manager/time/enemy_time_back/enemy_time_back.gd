extends Node


var time_back:Array[Vector2] = []
var index:int = 0:
	set(value):
		if value == 12:
			index = 0
		else:
			index = value


func _on_timer_timeout():
	if owner.faction == Global.Faction.Ying:
		remove_from_group("yang_time_back")
		add_to_group("ying_time_back")
	if owner.faction == Global.Faction.Yang:
		remove_from_group("ying_time_back")
		add_to_group("yang_time_back")
	if time_back.size()<12:
		time_back.append(owner.global_position)
	else:
		time_back[index] =owner.global_position
	index+=1


func load()->void:
	if time_back.size()<12:
		owner.global_position = time_back[0]
	else:
		owner.global_position = time_back[index]
	owner.health_manager.current_health = owner.health_manager.max_health
