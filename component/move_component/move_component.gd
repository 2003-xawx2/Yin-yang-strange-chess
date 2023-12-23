extends Node2D


var _if_walk:bool = true
@export var acceleration:int = 5
@export var max_speed:int = 200
@export var move_object:CharacterBody2D


func accelerate_to_direction(direction:Vector2,delta:float)->void:
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	if _if_walk:
		move_object.velocity = move_object.velocity.lerp(direction*max_speed,1-exp(-delta*acceleration))
	else:
		move_object.velocity = move_object.velocity.lerp(Vector2.ZERO,1-exp(-delta*acceleration))
	move_object.move_and_slide()


func if_walk(temp:bool)->void:
	_if_walk = temp
