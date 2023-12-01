class_name HitBox
extends Area2D

signal be_hit()

@export var health_component:HealthManager
#@export var collision_radiuis:= 20
@export_category("FloatingText")
@export var floating_text_scence:PackedScene = preload("res://component/floating_text/floating_text.tscn")
@export var blood_effect:PackedScene = preload("res://component/blood_effect/blood_effect.tscn")
@export var text_spawn_height := 20
@export var text_up_height :=40


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HurtBox:
		return

	if health_component==null:
		return
	
	area.hurt.emit()
	var hurt_box_component = area as HurtBox
	health_component.damage(hurt_box_component.damage)

	var floating_text = floating_text_scence.instantiate() as Node2D
	get_parent().get_parent().get_parent().add_child(floating_text)
	floating_text.global_position=global_position+Vector2.UP*text_spawn_height
	floating_text.start("%s"%hurt_box_component.damage,text_up_height)
	
	var blood := blood_effect.instantiate() as GPUParticles2D
	get_parent().get_parent().get_parent().add_child(blood)
	blood.global_position = global_position
	blood.look_at(-area.global_position + 2* global_position)
	
	if health_component.current_health>0:
		be_hit.emit()

