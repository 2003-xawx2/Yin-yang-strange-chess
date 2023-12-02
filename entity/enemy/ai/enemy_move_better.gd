extends Node2D

@onready var up = $up
@onready var down = $down
@onready var left = $left
@onready var right = $right
@onready var left_up = $left_up
@onready var right_up = $right_up
@onready var left_down = $left_down
@onready var right_down = $right_down


func update_colliding()->Vector2:
	var result:Vector2 = Vector2.ZERO
	if up.is_colliding():
		result-=Vector2.UP*100-up.get_collision_point()+global_position
	if down.is_colliding():
		result-=Vector2.DOWN*100-down.get_collision_point()+global_position
	if left.is_colliding():
		result-=Vector2.LEFT*100-left.get_collision_point()+global_position
	if right.is_colliding():
		result-=Vector2.RIGHT*100-right.get_collision_point()+global_position
	if left_up.is_colliding():
		result-=Vector2(-1,-1)*85-left_up.get_collision_point()+global_position
	if right_up.is_colliding():
		result-=Vector2(1,-1)*85-right_up.get_collision_point()+global_position
	if left_down.is_colliding():
		result-=Vector2(-1,1)*85-left_down.get_collision_point()+global_position
	if right_down.is_colliding():
		result-=Vector2(1,1)*85-right_down.get_collision_point()+global_position
	
	return result



