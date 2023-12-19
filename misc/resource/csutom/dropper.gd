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
@export var sprite:Texture = preload("res://assets/enemy/blood.png")
@export var type:Drop

static var drop_sprite:Dictionary = {
	Drop.bone:preload("res://assets/drop/drop_icon/骨头.png"),
	Drop.coin:preload("res://assets/drop/drop_icon/头.png"),
	Drop.snake_tooth:preload("res://assets/drop/drop_icon/毒牙.png"),
	Drop.snake_tail:preload("res://assets/drop/drop_icon/蛇信子.png"),
	Drop.frog_leg:preload("res://assets/drop/drop_icon/蹼.png"),
	Drop.frog_silk:preload("res://assets/drop/drop_icon/蜘蛛丝.png"),
	Drop.maggot_foot:preload("res://assets/drop/drop_icon/阴足.png"),
	Drop.maggot_link:preload("res://assets/drop/drop_icon/环节.png"),
}

static var drop_dic:Dictionary = {
	"bone":Drop.bone,
	"coin":Drop.coin,
	"snake_tooth":Drop.snake_tooth,
	"snake_tail":Drop.snake_tail,
	"frog_leg":Drop.frog_leg,
	"frog_silk":Drop.frog_silk,
	"maggot_foot":Drop.maggot_foot,
	"maggot_link":Drop.maggot_link,
}
