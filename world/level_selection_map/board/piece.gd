@tool
extends Sprite2D
class_name piece
signal correct
@export var initial_id:dropper.Drop = 0:
	set(value):
		if !is_node_ready():
			await ready
		chess.drop_id = value
	get:
		return chess.drop_id
@export var correct_id:dropper.Drop = 0
@export var target_exchange:Sprite2D
@onready var interact_collision: CollisionShape2D = $interact_area/CollisionShape2D


var if_correct:bool = false:
	set(value):
		if_correct = value
		if value == true:
			self_modulate = Color.GREEN
			correct.emit()
		else:
			self_modulate = Color.WHITE
	get:
		return if_correct
var chess: Sprite2D
var tween:Tween
var radius_move:=Vector2.ZERO
var circle_center := Vector2.ZERO
var tween_rotation :float = 0
static var can_interact:bool = true



func _ready() -> void:
	update_chess()
	set_process(false)


func _on_interact_area_interact() -> void:
	if !can_interact:
		return
	exchange_chess(target_exchange)
	target_exchange.exchange_chess(self)


func exchange_chess(temp:Sprite2D)->void:
	if tween and tween.is_running():
		tween.kill()
	
	radius_move = (global_position - temp.global_position)/2
	circle_center = (temp.global_position + global_position)/2
	tween_rotation = 0
	
	can_interact = false
	set_process(true)
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"tween_rotation",PI,.4)
	tween.tween_callback(_reparent.bind(temp))


func _process(delta: float) -> void:
	chess.global_position = radius_move.rotated(tween_rotation)+circle_center


func _reparent(temp:Sprite2D)->void:
	chess.global_position = temp.global_position
	chess.reparent(temp)
	set_process(false)
	await get_tree().process_frame
	update_chess()
	can_interact = true
	check_correct()
	get_parent().check()



func check_correct()->void:
	if chess.drop_id == correct_id:
		if_correct = true
	else:
		if_correct = false


func update_chess()->void:
	chess = get_child(1)


func success()->void:
	interact_collision.disabled = true
	chess.drop_id = correct_id
	check_correct()

