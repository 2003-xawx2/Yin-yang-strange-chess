@tool
extends Sprite2D
class_name chess

var icon_arr:Array[Texture]

@export_range(0,6) var drop_id:int:
	set(value):
		drop_id = value
		if !is_node_ready():
			await ready
		texture = icon_arr[value]
	get:
		return drop_id


func _ready() -> void:
	icon_arr =  [
	load("res://assets/drop/drop_icon/骨头.png"),
	load("res://assets/drop/drop_icon/头.png"),
	load("res://assets/drop/drop_icon/毒牙.png"),
	load("res://assets/drop/drop_icon/蛇信子.png"),
	load("res://assets/drop/drop_icon/蹼.png"),
	load("res://assets/drop/drop_icon/蜘蛛丝.png"),
	load("res://assets/drop/drop_icon/阴足.png"),
	load("res://assets/drop/drop_icon/环节.png"),
]
