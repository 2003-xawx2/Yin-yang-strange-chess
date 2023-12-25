extends Node2D
class_name board

var piece_array:Array
signal victory


func _ready() -> void:
	piece_array = get_children()
	piece_array = piece_array.filter(_filter)


func _filter(temp)->bool:
	if temp is piece:
		return true
	return false


func check()->void:
	var flag:=true
	for child in piece_array:
		if child.if_correct == false:
			flag = false
			break
	
	if flag:
		victory.emit()


func success()->void:
	for child in piece_array:
		child.success()
