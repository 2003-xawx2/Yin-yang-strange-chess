extends interact_area
class_name scene_tansfer

@export_file(".tscn") var path:String


func _interact()->void:
	super()
	Transition.change_to(path)
