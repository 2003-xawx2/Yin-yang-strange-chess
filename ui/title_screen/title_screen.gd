extends Control

const SETTING = "res://ui/setting/setting.tscn"
const level_map = "res://world/level_selection_map/level_selection_map.tscn"


func _on_start_pressed() -> void:
	Transition.change_to(level_map)


func _on_setting_pressed() -> void:
	Transition.change_to(SETTING)


func _on_quit_pressed() -> void:
	get_tree().quit()
