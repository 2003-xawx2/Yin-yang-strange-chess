extends Node2D

@onready var sprite_2d = $Graphic/Sprite2D
@onready var panel = $Graphic/Panel
@onready var graphic = $Graphic
@onready var hurt_box = $Graphic/HurtBox

func _ready():
	change_modulate(panel,1)


func try_to_settle()->void:
	pass


func settle_success()->void:
	change_modulate(panel,0)
	
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	queue_free()


func _process(delta):
	var center:Vector2 = Global.current_world.get_viewport_rect().size/2
	graphic.rotation = (center-global_position).angle()


func settle_fail()->void:
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"modulate:a",0,.5)
	change_modulate(panel,0)
	await tween.finished
	queue_free()


func change_modulate(object:Node,value:float)->void:
	if object == null:
		return
	var tween:=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(object,"modulate:a",value,.7)


func freeze()->void:
	var enemies:Array = hurt_box.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group("enemy"):
			enemy.stop_frames = 60
