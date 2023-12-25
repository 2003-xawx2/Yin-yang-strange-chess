extends Resource
class_name check_point

enum status{
	unchecked,
	checked,
	passed,
}

@export var check_name:String = "h1"
@export_multiline var description:String = "这是描述，这是描述，这是描述，这是描述，这是描述，这是描述，你看不懂哈哈哈"

@export var check_point_scene:PackedScene = preload("res://world/initial_world/initial_world.tscn")

@export var check_status:status = status.unchecked

@export var reward_tower:card_resource
