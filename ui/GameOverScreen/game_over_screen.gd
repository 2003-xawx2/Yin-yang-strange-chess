extends CanvasLayer


@onready var money: Label = $VBoxContainer/Money/Money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	var amount :int = Global.item.moneys
	money.text = str(amount/5)


func _on_button_pressed() -> void:
	Transition.change_to("res://world/level_selection_map/level_selection_map.tscn")
