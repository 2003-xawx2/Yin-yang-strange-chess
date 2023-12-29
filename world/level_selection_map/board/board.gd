extends Node2D
class_name board

var piece_array:Array
signal victory


func _ready() -> void:
	piece_array = get_children()
	piece_array = piece_array.filter(_filter)
	for _piece in piece_array:
		_piece.correct.connect(check)


func _filter(temp)->bool:
	if temp is piece:
		return true
	return false


func check()->bool:
	var flag:=true
	for child in piece_array:
		if child.if_correct == false:
			flag = false
			break
	
	if flag:
		victory.emit()
	
	return flag


func success()->void:
	for child in piece_array:
		child.success()


func disable()->void:
	for child in piece_array:
		child.disable()


func able()->void:
	for child in piece_array:
		child.able()
