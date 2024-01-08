extends MarginContainer

@onready var grid_container = $Panel/MarginContainer/VBoxContainer/GridContainer
@export var move_manager:Node:
	set(value):
		$Panel/MarginContainer/VBoxContainer/GridContainer.move_manager = value
		move_manager = value
	get:
		return move_manager


func _ready():
	get_tree().paused = true
	move_manager.out_place = grid_container
