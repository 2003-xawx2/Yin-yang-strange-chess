extends Node2D


@onready var maggot_scene = preload("res://entity/enemy/maggot/maggot.tscn")

@export var spawn_amounts:int = 6

var spawn_positions:Array[Vector2] = []
var spawn_position:Vector2

func _ready():
	for i in range(spawn_amounts):
		spawn_positions.append(Vector2.ONE.rotated(2*PI/spawn_amounts)*randf_range(10,20))
	

func spawn_maggot(faction:Global.Faction,target_global_position:Vector2)->void:
	for spawn_position_ in spawn_positions:
		var maggot_instance = maggot_scene.instantiate()
		get_parent().add_child(maggot_instance)
		maggot_instance.global_position = global_position+spawn_position_
		maggot_instance.spawn_position = spawn_position
		maggot_instance.target_global_position = target_global_position
		maggot_instance.faction = faction
		await get_tree().create_timer(.1).timeout
	queue_free()
