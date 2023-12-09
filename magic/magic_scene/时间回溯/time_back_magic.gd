extends Node2D



func _ready():
	pass # Replace with function body.


func try_to_settle()->void:
	pass


func settle_fail()->void:
	pass


func settle_success()->void:
	var choice:int = randi_range(1,3)
	match choice:
		1:
			var yings := get_tree().get_nodes_in_group("ying_time_back")
			for ying in yings:
				ying.load()
		2:
			var yangs := get_tree().get_nodes_in_group("yang_time_back")
			for yang in yangs:
				yang.load()
		3:
			Global.item.get_parent().load()
