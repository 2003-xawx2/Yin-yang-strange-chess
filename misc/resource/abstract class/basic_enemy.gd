extends CharacterBody2D
class_name basic_enemy

var on_screen_no:VisibleOnScreenNotifier2D
var if_in_screen:=false

func _ready():
	pass


func free_self()->void:
	pass


func on_arrived()->void:
	Global.arrived.emit()
	free_self()
