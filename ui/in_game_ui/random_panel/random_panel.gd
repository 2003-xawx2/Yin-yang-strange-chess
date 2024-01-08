extends Panel

@export var expence_on_ran:int =5
@export var card_velocity:float = 100
@export_category("show_up_frequency")
@export var basic_time_interval:float = 2
@export var time_offset:float = 1

@onready var amount_label = $Panel/MarginContainer/VBoxContainer/AmountLabel
@onready var magic_card_container = preload("res://magic/magic_card/magic_card_container.tscn")
@onready var spaw_position = $SpawPosition
@onready var timer = $Timer

const max_card_amounts:int=5
const card_interval:int = 140

var magic_resources:Array[magic_card]
var amounts_need_to_spawn:int:
	set(value):
		amount_label.text = "卡牌机里还有" + str(value) + "张"
		amounts_need_to_spawn = value
		if value > 0 and timer.is_stopped():
			timer.start(.5)
	get:
		return amounts_need_to_spawn

var weighted_magic:WeightedTable = WeightedTable.new()


func _ready():
	magic_resources = Global.tower_magic_savings.owned_magic
	for magic_card_ in magic_resources:
		weighted_magic.add_item(magic_card_,magic_card_.show_weight)
	start_random_cards(4)


func start_random_cards(amounts:int)->void:
	timer.start(basic_time_interval)
	amounts_need_to_spawn = amounts


func stop_random_cards()->void:
	timer.stop()


func _on_timer_timeout():
	if spaw_position.get_children().size() >=max_card_amounts:
		timer.start(randf_range(-time_offset,time_offset)+basic_time_interval)
		return
	var random_card = weighted_magic.pick_item()
	if random_card == null:return
	var instance = magic_card_container.instantiate()
	spaw_position.add_child(instance)
	instance.sprite = random_card.magic_icon
	instance.magic = random_card.magic
	instance.global_position = spaw_position.global_position
	
	amounts_need_to_spawn -= 1
	if amounts_need_to_spawn > 0:
		timer.start(randf_range(-time_offset,time_offset)+basic_time_interval)


func _on_button_pressed():
	var amounts :int= Global.item.item_amounts[Global.item.bone]
	if amounts < expence_on_ran:
		return
	Global.item.collect(dropper.Drop.bone,-expence_on_ran)
	amounts_need_to_spawn+=1


var time_back:Array[Array] = []
var index:int = 0:
	set(value):
		if value == 8:
			index = 0
		else:
			index = value


func save()->void:
	var temp_array:Array
	for child in spaw_position.get_children():
		var temp:Dictionary={}
		temp["global_position"] = child.global_position
		temp["magic"] = child.magic
		temp["sprite"] = child.sprite
		temp_array.append(temp)
	if time_back.size()<8:
		time_back.append(temp_array)
	else:
		time_back[index] = temp_array
	index+=1



func load()->void:
	for child in spaw_position.get_children():
		spaw_position.remove_child(child)
	
	var temp := time_back[index]
	
	for card_container in temp:
		var instance = magic_card_container.instantiate()
		spaw_position.add_child(instance)
		instance.sprite = card_container["sprite"]
		instance.magic = card_container["magic"]
		instance.global_position = card_container["global_position"]
