extends Panel

@onready var snake_tooth = $MarginContainer/Dropper/SnakeDrop/SnakeTooth
@onready var snake_tail = $MarginContainer/Dropper/SnakeDrop/SnakeTail
@onready var frog_leg = $MarginContainer/Dropper/FrogDrop/FrogLeg
@onready var frog_silk = $MarginContainer/Dropper/FrogDrop/FrogSilk
@onready var maggot_foot = $MarginContainer/Dropper/MaggotDrop/MaggotFoot
@onready var maggot_link = $MarginContainer/Dropper/MaggotDrop/MaggotLink
@onready var bone = $MarginContainer/Dropper/MiscDrop/Bone
@onready var coin = $MarginContainer/Dropper/MiscDrop/Coin

@onready var item_dictionary:Dictionary={
	dropper.Drop.bone:bone,
	dropper.Drop.coin:coin,
	dropper.Drop.maggot_link:maggot_link,
	dropper.Drop.maggot_foot:maggot_foot,
	dropper.Drop.frog_silk:frog_silk,
	dropper.Drop.frog_leg:frog_leg,
	dropper.Drop.snake_tail:snake_tail,
	dropper.Drop.snake_tooth:snake_tooth,
}

@onready var item_amounts:Dictionary={
	bone:0,
	coin:0,
	maggot_link:0,
	maggot_foot:0,
	frog_silk:0,
	frog_leg:0,
	snake_tail:0,
	snake_tooth:0,
}

func _ready():
	Global.item = self
	collect(dropper.Drop.coin,10)


func collect(drop:dropper.Drop,amount:int=1)->void:
	
	var dic:Dictionary = {}
	dic["drop"] = drop
	dic["amount"] = amount
	time_back[index] = dic
	index+=1
	
	var add_item = item_dictionary[drop] as Node
	item_amounts[add_item]+=amount
	if item_amounts[add_item]<0:
		item_amounts[add_item]=0
	#注意label是不是在containr的第二个child
	var label = add_item.get_child(1) as Label
	label.text = str(int(item_amounts[add_item]))


func _on_timer_timeout():
	collect(dropper.Drop.coin,1)


func fresh_label()->void:
	for drop in item_dictionary.keys():
		var add_item = item_dictionary[drop]
		#注意label是不是在containr的第二个child
		var label = add_item.get_child(1) as Label
		label.text = str(int(item_amounts[add_item]))



var time_back:Array[Dictionary] = [{},{}]
var index:int = 0:
	set(value):
		if value == 2:
			index = 0
		else:
			index = value


func save()->void:
	pass


func load()->void:
	for time in time_back:
		collect(time["drop"],-time["amount"])
