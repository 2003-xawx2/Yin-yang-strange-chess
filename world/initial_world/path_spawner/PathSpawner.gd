extends Node2D

signal victory

@onready var timer = $Timer
@onready var navigation_region_2d = $NavigationRegion2D
@onready var enemies:Array[PackedScene] = [
	preload("res://entity/enemy/initial_enemy/snake/d_snake.tscn"),
	preload("res://entity/enemy/initial_enemy/frog/d_frog.tscn"),
	preload("res://entity/enemy/initial_enemy/maggot/maggot_spawner.tscn")
]

@export_category("random_spawn")
@export var random_spawn:bool = false
@export var spawn_multipler:float = 1
@export_category("rule_spawn")
#@export var end_extra_time:= 30
@export var PathArray:Array[enemy_spawner]
var index:int=0
var spawn_time_line:Array[Dictionary] = []


func _ready():
	Global.current_world = get_parent()
	#转换一下时间线生成怪物
	
	if random_spawn:
		timer.start(.05)
		return
	
	for enemy in PathArray:
		for i in range(enemy.show_amounts): 
			var temp:Dictionary
			if enemy.show_interval == 0:
				enemy.show_interval = .1
			temp["time"] = enemy.showing_time + i * enemy.show_interval + .5
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
	#get_tree().call_group("order","queue_redraw")
	if !random_spawn:
		rule_spawn()
	else:
		rand_spawn()


func rand_spawn()->void:
	var start_position :int = randi_range(0,3)
	var end_position := (start_position+2)%4
	spawn_enemy(randi_range(0,2),start_position/2+1,start_position,end_position)
	timer.start(randf_range(0,1)/spawn_multipler)

 
func rule_spawn()->void:
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


func spawn_enemy(enemy_type:Global.EnemyType,enemy_faction:Global.Faction,spawn_position:int,end_position:int):
	var enemy_instance = enemies[enemy_type].instantiate()
	enemy_instance.spawn_position = get_child(spawn_position+1).global_position
	enemy_instance.global_position = get_child(spawn_position+1).global_position
	if enemy_type != Global.EnemyType.maggot:
		add_child(enemy_instance)
		enemy_instance.target_global_position = get_child(end_position+1).global_position
		enemy_instance.faction = enemy_faction
	else:
		add_child(enemy_instance)
		enemy_instance.spawn_maggot(enemy_faction,get_child(end_position+1).global_position)
