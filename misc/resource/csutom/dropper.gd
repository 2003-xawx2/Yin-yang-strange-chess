extends Resource
class_name dropper

enum Drop{
	bone,
	coin,
	snake_tooth,
	snake_tail,
	frog_leg,
	frog_silk,
	maggot_foot,
	maggot_link,
}

@export var weight:=1
@export var sprite:Texture
@export var type:Drop
