extends Node2D



func _ready():
	pass # Replace with function body.


func try_to_settle()->void:
	pass


func settle_fail()->void:
	pass


func settle_success()->void:
	$AnimationPlayer.play("roll")
	await $AnimationPlayer.animation_finished
	#$AnimationPlayer.play("roll")
	var choice:int = randi_range(1,3)
	$AnimationPlayer.speed_scale = .8
	match choice:
		1:
			$faction.play("ying")
			await $faction.animation_finished
			$AnimationPlayer.play("effect")
			var yings := get_tree().get_nodes_in_group("ying_time_back")
			for ying in yings:
				ying.load()
		2:
			$faction.play("yang")
			await $faction.animation_finished
			$AnimationPlayer.play("effect")
			var yangs := get_tree().get_nodes_in_group("yang_time_back")
			for yang in yangs:
				yang.load()
		3:
			$faction.play("human")
			await $faction.animation_finished
			$AnimationPlayer.play("effect")
			Global.item.get_parent().load()
	await $AnimationPlayer.animation_finished
	queue_free()
