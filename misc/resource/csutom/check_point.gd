extends Resource
class_name check_point

enum status{
	unchecked,
	checked,
	passed,
}

@export var check_name:String = "h1"
@export_multiline var description:String = "这是描述，这是描述，这是描述，这是描述，这是描述，这是描述，你看不懂哈哈哈"
@export_multiline var riddle:String = "你要写什么谜语？"

@export var check_point_scene:PackedScene = preload("res://world/initial_world/initial_world.tscn")

@export var check_score:String = "未通过"
@export var check_status:status = status.unchecked

@export var reward_tower:String = "倒转乾坤"


func update_score(score:String)->void:
	check_score = score
	ResourceSaver.save(self)


func reset()->void:
	check_name = "h1"
	description = "这是描述，这是描述，这是描述，这是描述，这是描述，这是描述，你看不懂哈哈哈"
	riddle = "你要写什么谜语？"
	check_point_scene= load("res://world/initial_world/initial_world.tscn")
	check_score = "未通过"
	check_status = status.unchecked
	reward_tower = "倒转乾坤"
	ResourceSaver.save(self)
