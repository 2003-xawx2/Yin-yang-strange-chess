extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grid_container: GridContainer = $Panel/MarginContainer/GridContainer
@onready var fresh: Button = $Panel/Fresh
@onready var amount: Label = $Panel/MoneyPanel/HBoxContainer/Amount

@export var fresh_price:=1000
@export var card_pool:Array[Resource]


const TOWER_MAGIC_SAVING = preload("res://world/level_selection_map/tower&magic_saving.tres")


func _ready() -> void:
	update_money()
	update_card_pool()

	var index := 0
	for child in grid_container.get_children():
		child.buy.connect(update_money)
		#update
		if index >= card_pool.size():
			child._card_resource = null
		else:
			child._card_resource = card_pool[index]
		index+=1


func update_money()->void:
	amount.text = str(TOWER_MAGIC_SAVING.moneys)
	for child in grid_container.get_children():
		child.if_buyable()
	if TOWER_MAGIC_SAVING.moneys < fresh_price:
		fresh.disabled = true
	else:
		fresh.disabled = false


func _on_button_pressed() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	get_parent().magic_tower_manual.update_manul_able()
	queue_free()


func update_card_pool()->void:
	card_pool = card_pool.filter(func(card:Resource):
		if card is magic_card:
			if TOWER_MAGIC_SAVING.owned_magic.has(card):
				return false
		else:
			if TOWER_MAGIC_SAVING.owned_tower.has(card):
				return false
		return true)

	card_pool.shuffle()


func _on_fresh_pressed() -> void:
	TOWER_MAGIC_SAVING.collect_moneys(-fresh_price)
	update_card_pool()
	update_money()

	var index := 0
	for child in grid_container.get_children():
		#update
		if index >= card_pool.size():
			child._card_resource = null
		else:
			child._card_resource = card_pool[index]
		index+=1
