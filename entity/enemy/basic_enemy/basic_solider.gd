extends CharacterBody2D


@export var max_speed :float = 1000
@export var acceleration :float = 300
@export var path :PathFollow2D

var speed:float = 0

func _ready():
	pass


func _process(delta):
	if speed <max_speed:
		speed += delta*acceleration
	path.set_progress(path.progress+speed*delta)
