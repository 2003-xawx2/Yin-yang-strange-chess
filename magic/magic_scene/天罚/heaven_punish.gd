extends Node2D

var thunder_scene:PackedScene = preload("res://magic/magic_scene/天罚/thunder.tscn")

func _ready():
	pass # Replace with function body.


func try_to_settle()->void:
	pass


func settle_fail()->void:
	pass


func settle_success()->void:
	var choice:int = randi_range(1,3)
	match choice:
		1:
			$AnimationPlayer.play("rain")
		2:
			$AnimationPlayer.play("clear")
		3:
			$AnimationPlayer.play("thunder")
	await $AnimationPlayer.animation_finished
	queue_free()


func rain()->void:
	var enemies:=get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.max_speed /=5
	await get_tree().create_timer(6).timeout
	#enemies=get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy!=null:
			enemy.max_speed *=5


func clear()->void:
	pass


func thunder()->void:
	for i in range(5,10):
		var thunder_instance = thunder_scene.instantiate()
		add_child(thunder_instance)
		var size:=get_viewport_rect().size
		thunder_instance.global_position = Vector2(randi_range(0,size.x),randi_range(0,size.y))
