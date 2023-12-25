extends Node2D
@export var camera_area:Sprite2D


func _ready():
	Global.game_over.connect(_restart)


func _restart()->void:
	get_tree().change_scene_to_file("res://world/initial_world/initial_world.tscn")


func _on_button_button_down():
	Engine.time_scale = 3


func _on_button_button_up():
	Engine.time_scale = 1
