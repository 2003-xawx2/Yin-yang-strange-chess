extends Node

signal start_game

signal game_over

signal arrived

var current_world:Node2D

var if_in_game:bool=false:
	set(value):
		if if_in_game == value:
			return
		if_in_game = value
		if value == true:
			start_game.emit()
		if value == false:
			game_over.emit()
	get:
		return if_in_game 

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
