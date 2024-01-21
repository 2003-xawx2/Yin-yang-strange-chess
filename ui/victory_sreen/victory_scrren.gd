extends CanvasLayer

@onready var score: Label = $VBoxContainer/Score/score
@onready var money: Label = $VBoxContainer/Money/money
const TOWER_MAGIC_SAVING = preload("res://world/level_selection_map/tower&magic_saving.tres")
const RECORD = preload("res://world/record_current_index/record.tres")

func _ready() -> void:
	get_tree().paused = true
	var amount :int = Global.item.moneys
	money.text = str(amount)
	TOWER_MAGIC_SAVING.collect_moneys(amount)

	var _score : float = Global.item.item_amounts[Global.item.item_dictionary[dropper.Drop.coin]]/float(Global.item.coins)
	var grade:String
	if _score > .9:
		grade = "优秀"
	elif _score > .75:
		grade = "良好"
	elif _score > .6:
		grade = "及格"
	else:
		grade = "继续加油"

	RECORD.update_grade(grade)
	score.text = grade


func _on_button_pressed() -> void:
	Transition.change_to("res://world/level_selection_map/level_selection_map.tscn")
