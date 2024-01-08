extends Resource
class_name  record_check_index


@export var current_index:int = -1
@export var grade:String = "未通过"


func update_current_index(index:int)->void:
	current_index = index
	ResourceSaver.save(self)


func update_grade(_grade:String)->void:
	grade = _grade
	ResourceSaver.save(self)


func reset()->void:
	current_index = -1
	grade = "未通过"
	ResourceSaver.save(self)
