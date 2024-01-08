extends Panel

signal buy

var _card_resource:Resource = preload("res://magic/magic_resource/同归于尽.tres"):
	set(value):
		_card_resource = value
		if _card_resource == null:
			manual_card._card_resource = load("res://magic/magic_resource/倒转乾坤.tres")
			manual_card.modulate = Color.AQUAMARINE
			manual_card.modulate.a = .5
			button.disabled = true
			manual_card.process_mode = Node.PROCESS_MODE_DISABLED
			button.text = "暂无商品"
			return
		manual_card.modulate = Color.WHITE
		button.disabled = false
		manual_card._card_resource = _card_resource
		price = _card_resource.price
		button.text = "¥"+str(price)
		if_buyable()
	get:
		return _card_resource

var price:int
@onready var manual_card: Panel = $MarginContainer/VBoxContainer/ManualCard
@onready var button: Button = $MarginContainer/VBoxContainer/Button

const TOWER_MAGIC_SAVING = preload("res://world/level_selection_map/tower&magic_saving.tres")


func if_buyable()->void:
	if price > TOWER_MAGIC_SAVING.moneys:
		button.disabled = true
	else:
		button.disabled = false


func _on_button_pressed() -> void:
	TOWER_MAGIC_SAVING.collect_moneys(-price)
	TOWER_MAGIC_SAVING.add(_card_resource.name)
	manual_card.new_card()
	button.disabled = true
	buy.emit()
