extends Node2D

@onready var luo_shu: Node2D = $LuoShu
@onready var animation_player: AnimationPlayer = $OutGameUi/AnimationPlayer
@onready var check_name: Label = $OutGameUi/Panel/MarginContainer/VBoxContainer/CheckName
@onready var check_decription: Label = $OutGameUi/Panel/MarginContainer/VBoxContainer/CheckDecription
@onready var camera: Camera2D = $Camera2D

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
	update_stats()
	var i := 0
	for _check_point in check_points:
		_check_point.interact.connect(_on_interact.bind(i))
		_check_point.get_child(0).victory.connect(_on_success.bind(i))
		i+=1
	#连接信号

#更新每个关卡的状态
func update_stats()->void:
	var i := 0
	for _check_point in check_points:
		match(check_point_resources[i].check_status):
			check_point.status.unchecked:
				_check_point.get_child(0).process_mode = PROCESS_MODE_DISABLED
			check_point.status.checked:
				if if_check:
					_check_point.get_child(0).process_mode = PROCESS_MODE_INHERIT
				else:
					_check_point.get_child(0).process_mode = PROCESS_MODE_DISABLED
			check_point.status.passed:
				_check_point.get_child(0).success()
				_check_point.get_child(0).process_mode = PROCESS_MODE_DISABLED
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
	ease_in(center_position,min_zoom)
	hide_ui()
	await tween.finished
	if_check = false

#展示卷轴
func show_ui()->void:
	await get_tree().create_timer(.5).timeout
	check_name.text = current_check.check_name
	check_decription.text = current_check.description
	animation_player.play("ease_in")
	update_stats()

#隐藏卷轴
func hide_ui()->void:
	animation_player.play_backwards("ease_in")
	update_stats()

#棋盘谜题解开的逻辑
func _on_success(i:int)->void:
	var vic_check := check_point_resources[i]
	vic_check.check_status = check_point.status.passed
	ResourceSaver.save(vic_check)
	update_stats()

#点击关卡的逻辑
func _on_interact(_check_point:int) -> void:
	if if_check:
		return
	if_check = true
	current_check = check_point_resources[_check_point]
	ease_in(check_points[_check_point].global_position+camera_offset,max_zoom)
	show_ui()

#摄像头的移动实现
func _process(delta: float) -> void:
	if if_check:
		return
	var mouse_position_y := get_viewport().get_mouse_position().y
	var mouse_position_x := get_viewport().get_mouse_position().x
	if mouse_position_y < 256 and mouse_position_x > 300:
		camera.position.y -= (256 - mouse_position_y) *delta *camera_mul
	elif mouse_position_y > 1052:
		camera.position.y += (mouse_position_y - 1052) *delta *camera_mul


func _on_start_game_pressed() -> void:
	Transition.change_to(current_check.check_point_scene.resource_path)


func _on_back_pressed() -> void:
	if tween and tween.is_running():
		return
	if if_check:
		back_to_center()
	else:
		Transition.change_to("res://ui/title_screen/title_screen.tscn")
