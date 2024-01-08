@tool
extends Sprite2D
class_name piece

signal correct
@export var initial_id:dropper.Drop = 0:
	set(value):
		if !is_node_ready():
			await ready
		_chess.drop_id = value
	get:
		if _chess:
			return _chess.drop_id
		return 0
@export var correct_id:dropper.Drop = 0
@export var target_exchange:Sprite2D
@onready var panel: Panel = $Panel
@onready var interact_collision: CollisionShape2D = $interact_area/CollisionShape2D
@onready var correct_detect_timer: Timer = $CorrectDetectTimer


var if_correct:bool = false
var _chess: Sprite2D
var tween:Tween
var line_sprite:Sprite2D
var radius_move:=Vector2.ZERO
var circle_center := Vector2.ZERO
var tween_rotation :float = 0
static var can_interact:bool = true
var line_m_a := 0


func _ready() -> void:
	update_chess()
	set_process(false)
	check_correct.call_deferred(true)
	if target_exchange == null:
		print_debug("target_exchange == null!")
		return
	line_sprite = Sprite2D.new()
	add_child(line_sprite)
	line_sprite.modulate.a = line_m_a
	line_sprite.z_index = -1
	line_sprite.texture = load("res://assets/level_select&borad/board/pngwing.com.png")
	line_sprite.global_position = (global_position + target_exchange.global_position)/2
	line_sprite.scale = Vector2.ONE * (global_position.distance_to(target_exchange.global_position)/1000)


func _on_interact_area_interact() -> void:
	if !can_interact or target_exchange == null:
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
	_chess.global_position = radius_move.rotated(tween_rotation)+circle_center


func _reparent(temp:Sprite2D)->void:
	_chess.global_position = temp.global_position
	_chess.reparent(temp)
	set_process(false)
	await get_tree().process_frame
	update_chess()
	can_interact = true
	check_correct()


func check_correct(flag:=false)->void:
	if _chess.drop_id == correct_id:
		change_green(Color.GREEN)
		if flag:
			if_correct = true
		else:
			correct_detect_timer.start()
	else:
		change_green(Color.WHITE)
		correct_detect_timer.stop()
		if_correct = false


func update_chess()->void:
	for child in get_children():
		if child is chess:
			_chess = child
			break


func success()->void:
	interact_collision.disabled = true
	_chess.drop_id = correct_id
	check_correct(true)


var line_tween:Tween
var if_mouse_in:bool = false:
	set(value):
		if_mouse_in = value
		if line_sprite == null:
			return
		if line_tween and line_tween.is_running():
			tween.kill()
		tween = create_tween().set_ease(Tween.EASE_OUT)
		if value == true:
			tween.tween_property(line_sprite,"modulate:a",1,.3)
		else:
			tween.tween_property(line_sprite,"modulate:a",line_m_a,.3)
	get:
		return if_mouse_in


func _on_panel_mouse_entered() -> void:
	if_mouse_in = true


func _on_panel_mouse_exited() -> void:
	if_mouse_in = false


func _on_correct_detect_timer_timeout() -> void:
	if_correct = true
	correct.emit()


func disable()->void:
	interact_collision.disabled = true
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE


func able()->void:
	interact_collision.disabled = false
	panel.mouse_filter = Control.MOUSE_FILTER_PASS


var green_tween:Tween
func change_green(_modulate:Color)->void:
	if green_tween and green_tween.is_running():
		green_tween.kill()
	green_tween = create_tween().set_ease(Tween.EASE_IN)
	green_tween.tween_property(self,"self_modulate",_modulate,1)
