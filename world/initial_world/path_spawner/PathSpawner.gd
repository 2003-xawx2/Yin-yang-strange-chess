extends Node2D

@onready var timer = $Timer
@onready var navigation_region_2d = $NavigationRegion2D
@onready var enemies:Array[PackedScene] = [
	preload("res://entity/enemy/snake/snake.tscn"),
	preload("res://entity/enemy/frog/frog.tscn"),
	preload("res://entity/enemy/maggot/maggot.tscn")
]

@export var PathArray:Array[enemy_spawner]
var index:int=0
var spawn_time_line:Array[Dictionary] = []


func _ready():
	Global.current_world = get_parent()
	#转换一下时间线生成怪物
	for enemy in PathArray:
		for i in range(enemy.show_amounts): 
			var temp:Dictionary
			temp["time"] = enemy.showing_time + i * enemy.show_interval
			temp["enemy_type"] = enemy.enemy_type
			temp["enemy_faction"] = enemy.enemy_faction
			temp["spawn_position"] = enemy.spawn_position
			temp["end_position"] = enemy.end_position
			spawn_time_line.append(temp)
	
	spawn_time_line.sort_custom(_sort)
	timer.start(.05)


func _sort(temp_a:Dictionary,temp_b:Dictionary)->bool:
	if temp_b["time"]>=temp_a["time"]:
		return true
	else:
		return false


func _on_timer_timeout():
	spawn_enemy(spawn_time_line[index]["enemy_type"],spawn_time_line[index]["enemy_faction"],\
	spawn_time_line[index]["spawn_position"],spawn_time_line[index]["end_position"])
	
	if index+1 == spawn_time_line.size():return
	
	var delta_time :float =  spawn_time_line[index+1]["time"] - spawn_time_line[index]["time"]
	while delta_time==0:
		index+=1
		spawn_enemy(spawn_time_line[index]["enemy_type"],spawn_time_line[index]["enemy_faction"],\
	spawn_time_line[index]["spawn_position"],spawn_time_line[index]["end_position"])
		if index+1 == spawn_time_line.size():return
		delta_time = spawn_time_line[index+1]["time"] - spawn_time_line[index]["time"]
	index+=1
	if index != spawn_time_line.size():
		timer.start(delta_time)


func spawn_enemy(enemy_type:Global.EnemyType,enemy_faction:Global.Faction,spawn_position:Node2D,end_position:Node2D):
	var enemy_instance = enemies[enemy_type].instantiate()
	enemy_instance.faction = enemy_faction
	enemy_instance.global_position = spawn_position.global_position
	add_child(enemy_instance)
	enemy_instance.target_global_position = end_position.global_position
