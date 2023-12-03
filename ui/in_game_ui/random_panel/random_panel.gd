extends Panel

@export var magic_resources:Array[magic_card]
@export var card_velocity:float = 100
@export_category("show_up_frequency")
@export var basic_time_interval:float = 2
@export var time_offset:float = 1

@onready var magic_card_container = preload("res://magic/magic_card/magic_card_container.tscn")
@onready var spaw_position = $SpawPosition
@onready var timer = $Timer

const max_card_amounts = 18
const card_interval:int = 140

var amounts_need_to_spawn:int = 0
var weighted_magic:WeightedTable = WeightedTable.new()

func _ready():
	for magic_card_ in magic_resources:
		weighted_magic.add_item(magic_card_,magic_card_.show_weight)
	start_random_cards(30)


func start_random_cards(amounts:int)->void:
	timer.start(basic_time_interval)
	amounts_need_to_spawn = amounts


func stop_random_cards()->void:
	timer.stop()


func _on_timer_timeout():
	if spaw_position.get_children().size() >=max_card_amounts:
		return
	var instance = magic_card_container.instantiate()
	spaw_position.add_child(instance)
	var random_card = weighted_magic.pick_item()
	instance.sprite = random_card.magic_icon
	instance.magic = random_card.magic
	instance.global_position = spaw_position.global_position
	
	amounts_need_to_spawn -= 1
	if amounts_need_to_spawn > 0:
		timer.start(randf_range(-time_offset,time_offset)+basic_time_interval)









