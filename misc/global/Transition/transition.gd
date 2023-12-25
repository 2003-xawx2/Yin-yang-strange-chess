extends CanvasLayer


func _ready() -> void:
	hide()


func change_to(path:String)->void:
	show()
	$AnimationPlayer.play("ease_in")
	await $AnimationPlayer.animation_finished
	change(path)
	$AnimationPlayer.play("ease_out")
	await $AnimationPlayer.animation_finished
	hide()
	get_tree().paused = false


func change(path:String)->void:
	get_tree().change_scene_to_file(path)
