extends Control

@onready var description: Label = $Description/VBoxContainer/Description
@onready var card_name: Label =$Description/VBoxContainer/Name
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_container: Panel = $Description
@onready var card: Sprite2D = $Card
@onready var back_sprite: Sprite2D = $Description/Sprite2D


@export var big_position:Vector2 = Vector2(0,0)
@export var _card_resource:Resource:
	set(value):
		if !is_node_ready():
			await ready
		_card_resource = value
		description.text = _card_resource.description
		card_name.text = _card_resource.name
		back_sprite.texture = _card_resource.card_sprite
		if value is card_resource:
			card.texture = value.tower_sprite
		elif value is magic_card:
			card.texture = value.magic_icon
	get:
		return _card_resource

enum Status {hide,small,big}

var status:Status
var tween:Tween


func _ready() -> void:
	description_container.modulate.a = 0
	status = Status.small


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		if status == Status.small:
			go_to_center()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if status == Status.big:
			back_to_origin()


func back_to_origin()->void:
	$GPUParticles2D.emitting = false
	z_index = 0
	tween_position(Vector2.ZERO)
	animation_player.play_backwards("ease_in")
	await get_tree().process_frame
	status = Status.small


func go_to_center()->void:
	z_index = 99
	tween_position(big_position - global_position)
	animation_player.play("ease_in")
	await get_tree().process_frame
	status = Status.big


func tween_position(target_position:Vector2,tween_time:float = .4)->void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"position",target_position,tween_time)


func new_card()->void:
	if tween and tween.is_running():
		tween.kill()
	global_position = big_position
	animation_player.play("new")
	await get_tree().process_frame
	status = Status.big
	await animation_player.animation_finished


