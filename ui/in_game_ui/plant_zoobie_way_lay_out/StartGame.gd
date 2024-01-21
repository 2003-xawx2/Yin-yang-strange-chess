extends Button



func _on_pressed():

	Global.emit_start_game()
	$"../../../../../AnimationPlayer".play_backwards("ease_in")
	get_tree().paused = false
