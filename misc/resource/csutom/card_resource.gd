extends Resource
class_name card_resource

@export var name:String
@export_multiline var description:String
@export var fail_settle_cool_time:float=0.5
@export var success_settle_cool_time:float = 3
@export var tower_sprite:Texture = preload("res://assets/tower_defense/PNG/Default size/towerDefense_tile026.png")
@export var card_sprite:Texture = preload("res://assets/magic_card/card_back/乾坤卡牌.png")
@export var basic_tower:PackedScene = preload("res://entity/tower/basic_tower/basic_tower.tscn")

@export var consume:Dictionary = {
	"bone":0,
	"coin":0,
	"snake_tooth":0,
	"snake_tail":0,
	"frog_leg":0,
	"frog_silk":0,
	"maggot_foot":0,
	"maggot_link":0,
}
