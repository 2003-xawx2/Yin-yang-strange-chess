extends Resource
class_name magic_card

@export var name:String
@export_multiline var description:String
@export var show_weight:int = 1
@export var magic_icon:Texture = preload("res://assets/tower_defense/PNG/Default size/towerDefense_tile026.png")
@export var card_sprite:Texture = preload("res://assets/magic_card/card_back/乾坤卡牌.png")
@export var magic:PackedScene = preload("res://entity/tower/basic_tower/basic_tower.tscn")

