extends Node

var current_world:Node2D

var if_in_game:bool=false

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

