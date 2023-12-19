extends GridContainer

@export var cards:Array[card_resource]
@export var move_manager:Node

func  _ready():
	var i:int =0
	for child in get_children():
		if i<cards.size():
			child.set_card(i,cards[i].fail_settle_cool_time,cards[i].success_settle_cool_time,\
			cards[i].tower_sprite,cards[i].basic_tower,cards[i].consume,cards[i].description,move_manager)
		else:
			child.remove_card()
		i+=1


