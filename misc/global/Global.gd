extends Node

signal start_game

signal game_over

signal victory

signal arrived


var if_in_game:bool=false:
	set(value):
		if if_in_game == value:
			return
		if_in_game = value
		if value == true:
			start_game.emit()
	get:
		return if_in_game 


func emit_start_game()->void:
	if_in_game = true
	start_game.emit()


func emit_victory()->void:
	if_in_game = false
	victory.emit()


func emit_game_over()->void:
	if_in_game = false
	game_over.emit()


var tower_magic_savings := preload("res://world/level_selection_map/tower&magic_saving.tres")

var current_world:Node2D
var camera:Camera2D
var item:Panel

enum Faction{
	Human,
	Ying,
	Yang
}
enum EnemyType {
	snake,
	frog,
	maggot
}


func _ready() -> void:
	tower_magic_savings.add("蛆怒症")
