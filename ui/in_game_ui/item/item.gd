extends Panel

signal changed

@onready var snake_tooth = $MarginContainer/Dropper/SnakeDrop/SnakeTooth
@onready var snake_tail = $MarginContainer/Dropper/SnakeDrop/SnakeTail
@onready var frog_leg = $MarginContainer/Dropper/FrogDrop/FrogLeg
@onready var frog_silk = $MarginContainer/Dropper/FrogDrop/FrogSilk
@onready var maggot_foot = $MarginContainer/Dropper/MaggotDrop/MaggotFoot
@onready var maggot_link = $MarginContainer/Dropper/MaggotDrop/MaggotLink
@onready var bone = $MarginContainer/Dropper/MiscDrop/Bone
@onready var coin = $MarginContainer/Dropper/MiscDrop/Coin

@onready var flow_text :=preload("res://component/floating_text/floating_text.tscn")
var flow_text_offset = Vector2(90,40)

@export var arrive_cost:=2

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
	Global.arrived.connect(collect.bind(dropper.Drop.coin,-arrive_cost))
	collect(dropper.Drop.coin,10)


func collect(drop:dropper.Drop,amount:int=1)->void:
	if amount == 0:return
	var dic:Dictionary = {}
	dic["drop"] = drop
	dic["amount"] = amount
	time_back[index] = dic
	index+=1
	
	if drop!=dropper.Drop.coin:
		if amount>0:
			floating_text.call_deferred(item_dictionary[drop].global_position,"+"+str(amount))
		else:
			floating_text.call_deferred(item_dictionary[drop].global_position,"-"+str(-amount))
	else:
		if amount>0:
			floating_text.call_deferred(item_dictionary[drop].global_position,"+"+str(amount),Color.GREEN)
		else:
			floating_text.call_deferred(item_dictionary[drop].global_position,"-"+str(-amount),Color.RED)
	await get_tree().create_timer(.1).timeout
	
	var add_item = item_dictionary[drop] as Node
	item_amounts[add_item]+=amount
	if item_amounts[add_item]<0:
		item_amounts[add_item]=0
		if drop==dropper.Drop.coin:
			Global.if_in_game = false
	#注意label是不是在containr的第二个child
	var label = add_item.get_child(1) as Label
	label.text = str(int(item_amounts[add_item]))
	
	changed.emit()


func floating_text(_position:Vector2,content:String,_modulate:Color = Color.WHITE)->void:
	var text = flow_text.instantiate()
	get_parent().add_child(text)
	text.global_position = _position+flow_text_offset
	text.start(content)
	text.modulate = _modulate


func _on_timer_timeout():
	if Global.if_in_game:
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
