extends Node2D
class_name basic_world

@export var current_world_index:=2


var game_over_scene = preload("res://ui/GameOverScreen/game_over_screen.tscn")
var victory_scene = preload("res://ui/victory_sreen/victory_scrren.tscn")


func _ready() -> void:
	Global.current_world = self
	Global.game_over.connect(func()->void:
		add_child(game_over_scene.instantiate()))
	Global.victory.connect(func()->void:
		add_child(victory_scene.instantiate())
		if current_world_index > Global.tower_magic_savings.check_index:
			Global.tower_magic_savings.update_check_index(current_world_index))
