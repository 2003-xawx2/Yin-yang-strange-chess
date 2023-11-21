extends Node2D

@onready var path_stage_1 = preload("res://world/initial_world/path/stage_1_path.tscn")
@export var spawn_time:=3


func _ready():
	$Timer.start(spawn_time)


func _on_timer_timeout():
	var path_stage_1_instance = path_stage_1.instantiate()
	add_child(path_stage_1_instance)
