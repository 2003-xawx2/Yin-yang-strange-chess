extends Node2D

@export var sprite:Sprite2D
@export var color:Color
@export var fade_time:float = .1

@onready var  ghost_scence:PackedScene = preload("res://component/ghost/ghost.tscn")


func start_spawn()->void:
	$Timer.start(0.02)
#	get_tree().create_timer(time).timeout
#	stop_spawn()


func stop_spawn()->void:
	await get_tree().create_timer(0.08).timeout
	$Timer.stop()


func _on_timer_timeout():
	var instance = ghost_scence.instantiate() as Sprite2D
	get_parent().get_parent().add_child(instance)
	instance.global_position = sprite.global_position
	instance.texture = sprite.texture
	instance.self_modulate = color
	instance.scale = sprite.scale
	instance.rotation = sprite.rotation
	instance.fade_time = fade_time
	instance.z_index = 0
