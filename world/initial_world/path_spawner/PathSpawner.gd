extends Node2D

@export var PathArray:Array[PackedScene]
@export var spawn_time:float = 3


func _ready():
	$Timer.start(spawn_time)
	Global.current_world = get_parent()


func _on_timer_timeout():
	for path in PathArray:
		var path_stage_1_instance = path.instantiate()
		add_child(path_stage_1_instance)
