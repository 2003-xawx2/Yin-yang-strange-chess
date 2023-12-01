extends Button



func _on_pressed():
	
	Global.if_in_game = true
	$"../../../../../AnimationPlayer".play_backwards("ease_in")
	get_tree().paused = false
