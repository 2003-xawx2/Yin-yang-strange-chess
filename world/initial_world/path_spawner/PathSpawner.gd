extends Node2D

@export var PathArray:Array[PackedScene]
@export var spawn_time:float = 3


func _ready():
	$Timer.start(spawn_time)
	Global.current_world = get_parent()


func _on_timer_timeout():
	var i:int = 0
	for child in get_children():
		if child is Timer:continue
		child.add_child(PathArray[i%2].instantiate())
		i+=1
