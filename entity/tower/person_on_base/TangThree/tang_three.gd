extends basic_human

@onready var buddhist := preload("res://entity/tower/person_on_base/TangThree/buddhist.tscn")
@onready var attack_timer: Timer = $AttackTimer
@onready var gooden_holp := preload("res://entity/tower/person_on_base/TangThree/gooden_holp.tscn")

@export var first_attack_interval:float = 2
@export var attack_interval:float = 3


func _ready() -> void:
	super._ready()
	animation_player.play("idle")


func small_attack()->void:
	target = return_target()
	if target == null:
		return
	update_direction()
	recoil()
	var bullet:=buddhist.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func hurt_attack()->void:
	target = return_target()
	if target == null:
		return
	update_direction()
	var bullet:= gooden_holp.instantiate()
	bullet.enemy_tracked = target
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func update_enemies_attack()->void:
	enemies = detect_area.get_overlapping_bodies()
	if return_target() == null:
		attack_timer.stop()
		$AnimationPlayer.queue("idle")
	else:
		attack_timer.start(first_attack_interval)


func _on_attack_timer_timeout() -> void:
	var choice:int = randi_range(0,2)
	match(choice):
		0:
			$AnimationPlayer.play("attack")
			await get_tree().create_timer(.2).timeout
			hurt_attack()
		1:
			$AnimationPlayer.play("attack")
			await get_tree().create_timer(.15).timeout
			small_attack()
		2:
			pass
	attack_timer.start(attack_interval)
