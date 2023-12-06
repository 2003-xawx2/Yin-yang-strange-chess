extends Node2D

@export_range(0,1) var drop_percent:float = .5
@export var health_manager:HealthManager
@export var droppers:Array[dropper]

@onready var dropper_scene = preload("res://c_manager/drop_manager/dropper.tscn")

var weighted_drop := WeightedTable.new()


func _ready():
	health_manager.die.connect(_on_health_died)
	for drop in droppers:
		weighted_drop.add_item(drop,drop.weight)


func _on_health_died()->void:
	if randf_range(0,1)>drop_percent:
		return
	var drop_type = weighted_drop.pick_item()
	var drop = dropper_scene.instantiate()
	get_parent().get_parent().add_child(drop)
	drop.type = drop_type.type
	#drop.sprite = drop_type.sprite
	drop.global_position = global_position
	drop.init()
