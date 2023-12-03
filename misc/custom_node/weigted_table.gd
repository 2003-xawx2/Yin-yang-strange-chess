class_name WeightedTable


var items:Array[Dictionary] = []
var weight_sum:int = 0


func add_item(item,weight:int)->void:
	items.append({"item":item,"weight":weight})
	weight_sum+=weight


func pick_item():
	var chosen_weight = randi_range(1,weight_sum)
	for item in items:
		chosen_weight-=item["weight"]
		if chosen_weight<=0:
			return item["item"]
