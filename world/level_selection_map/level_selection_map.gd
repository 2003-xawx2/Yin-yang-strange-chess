extends Node2D

@onready var luo_shu: Node2D = $LuoShu
@onready var animation_player: AnimationPlayer = $OutGameUi/AnimationPlayer
@onready var check_name: Label = $OutGameUi/Panel/MarginContainer/VBoxContainer/CheckName
@onready var check_decription: Label = $OutGameUi/Panel/MarginContainer/VBoxContainer/CheckDecription
@onready var camera: Camera2D = $Camera2D
@onready var status: Label = $OutGameUi/Panel/MarginContainer/VBoxContainer/Status
@onready var start_game: Button = $OutGameUi/Panel/MarginContainer/VBoxContainer/StartGame
@onready var magic_tower_manual: CanvasLayer = $MagicTowerManual

const RECORD = preload("res://world/record_current_index/record.tres")
const SHOP = preload("res://ui/shop/shop.tscn")
const center_position = Vector2(1216,384)

@export var check_point_resources:Array[check_point]

@export_category("camera")
@export var camera_mul:int = 10
@export var max_zoom:Vector2
@export var min_zoom:Vector2
@export var camera_offset:Vector2 = Vector2(380,0)

var current_check:check_point
var check_points:Array
var tween:Tween
var if_check: = false


func _ready() -> void:
	check_points = luo_shu.get_children()
	update_progress()
	update_stats()
	
	var current_index = RECORD.current_index
	if current_index != -1:
		_on_interact(current_index)
	
	var i := 0
	for _check_point in check_points:
		_check_point.interact.connect(_on_interact.bind(i))
		_check_point.get_child(0).victory.connect(_on_success.bind(i))
		i+=1
	#连接信号


func update_progress()->void:
	var c_index := Global.tower_magic_savings.check_index
	if c_index == 0:
		return
	var vic_check := check_point_resources[c_index -1]
	if vic_check.check_status == check_point.status.passed:
		return
	special_index(c_index)
	if vic_check.check_status == check_point.status.passed:
		vic_check.update_score(RECORD.grade)
		return
	vic_check.check_status = check_point.status.checked
	ResourceSaver.save(vic_check)

#更新每个关卡的状态
func update_stats()->void:
	var i := 0
	for _check_point in check_points:
		match(check_point_resources[i].check_status):
			check_point.status.unchecked:
				_check_point.get_child(0).disable()
			check_point.status.checked:
				if if_check:
					_check_point.get_child(0).able()
				else:
					_check_point.get_child(0).disable()
			check_point.status.passed:
				_check_point.get_child(0).success()
				_check_point.get_child(0).disable()
		#看资源文件里的if_check把棋盘设置成不能动的
		i+=1

#摄像头移动到指定放大位置
func ease_in(target_position:Vector2,target_zoom:Vector2)->void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_property(camera,"zoom",target_zoom,.7)
	tween.tween_property(camera,"global_position",target_position,.7)
	tween.chain()

#摄像头回到正中心
func back_to_center()->void:
	RECORD.update_current_index(-1)
	ease_in(center_position,min_zoom)
	hide_ui()
	await tween.finished
	if_check = false

#展示卷轴
func show_ui()->void:
	check_name.text = current_check.check_name
	if current_check.check_status == check_point.status.unchecked:
		check_decription.text = current_check.description
		status.text = "未通过"
	else:
		check_decription.text = current_check.riddle
		status.text = current_check.check_score
	await get_tree().create_timer(.5).timeout
	animation_player.play("ease_in")
	update_stats()

#隐藏卷轴
func hide_ui()->void:
	animation_player.play_backwards("ease_in")
	update_stats()

#棋盘谜题解开的逻辑
func _on_success(i:int)->void:
	status.text = current_check.check_score
	var vic_check := check_point_resources[i]
	vic_check.check_status = check_point.status.passed
	ResourceSaver.save(vic_check)
	Global.tower_magic_savings.add(current_check.reward_tower)
	magic_tower_manual.get_new_card(current_check.reward_tower)
	update_stats()
	#
	if i > Global.tower_magic_savings.check_index:
		Global.tower_magic_savings.update_check_index(i)

#点击关卡的逻辑
func _on_interact(_check_point:int) -> void:
	if if_check:
		return
	if_check = true
	current_check = check_point_resources[_check_point]
	RECORD.update_current_index(_check_point)
	ease_in(check_points[_check_point].global_position+camera_offset,max_zoom)
	show_ui()
	magic_tower_manual.hide_manual()
	#
	if _check_point > Global.tower_magic_savings.check_index:
		start_game.disabled = true
	else:
		start_game.disabled = false

#摄像头的移动实现
func _process(delta: float) -> void:
	if if_check or !magic_tower_manual.if_fold:
		return
	var mouse_position_y := get_viewport().get_mouse_position().y
	var mouse_position_x := get_viewport().get_mouse_position().x
	if mouse_position_y < 256 and mouse_position_x > 600:
		camera.position.y -= (256 - mouse_position_y) *delta *camera_mul
	elif mouse_position_y > 1052:
		camera.position.y += (mouse_position_y - 1052) *delta *camera_mul


func _on_start_game_pressed() -> void:
	Transition.change_to(current_check.check_point_scene.resource_path)


func _on_back_pressed() -> void:
	magic_tower_manual.hide_manual()
	if tween and tween.is_running():
		return
	if if_check:
		back_to_center()
	else:
		Transition.change_to("res://ui/title_screen/title_screen.tscn")


func _on_shop_pressed() -> void:
	add_child(SHOP.instantiate())


func special_index(index:int)->void:
	if index == 1:
		var special_check = check_point_resources[index]
		Global.tower_magic_savings.add(special_check.reward_tower)
		magic_tower_manual.get_new_card(special_check.reward_tower)
		var vic_check := check_point_resources[0]
		vic_check.check_status = check_point.status.passed
		ResourceSaver.save(vic_check)


func reset()->void:
	RECORD.reset()
	Global.tower_magic_savings.reset()
	for _check_point in check_point_resources:
		(_check_point as check_point).reset()
