extends Node2D

@onready var enemy_move_better = $EnemyMoveBetter


func _physics_process(delta):
	$Label.text = str(enemy_move_better.update_colliding())
	$RayCast2D.target_position = enemy_move_better.update_colliding()

func _input(event):
	if event is InputEventMouse:
		enemy_move_better.global_position = event.position
