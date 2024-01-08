extends CanvasLayer

@onready var scroll_container: ScrollContainer = $Control/ScrollContainer
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var grid_container: GridContainer = $Control/ScrollContainer/GridContainer
@onready var magic_tower_saving := Global.tower_magic_savings
@onready var manual_card_scene := preload("res://ui/magic_tower_manual/slot/manual_slot.tscn")

@export var big_position:Vector2 = Vector2(800,580)
var manual_cards:Array

func _ready() -> void:
	initial_manul_able()
	update_manul_able()


func initial_manul_able()->void:
	var magics_towers :Dictionary= magic_tower_saving.resources_dic
	for resource in magics_towers.values():
		var manual_card_ins := manual_card_scene.instantiate()
		manual_cards.append(manual_card_ins)
		grid_container.add_child(manual_card_ins)
		manual_card_ins.get_child(0)._card_resource = resource
		manual_card_ins.get_child(0).big_position = big_position
		#if magics_towers[resource] == false:
			#manual_card_ins.modulata = Color.SLATE_GRAY
		#else:
			#manual_card_ins.modulata = Color.WHITE


func update_manul_able()->void:
	var magics:= magic_tower_saving.owned_magic
	var towers :=magic_tower_saving.owned_tower
	for manual_card in grid_container.get_children():
		var temp_r :Resource= manual_card.get_child(0)._card_resource
		if temp_r is magic_card:
			if magics.has(temp_r):
				manual_card.get_child(0).modulate = Color.WHITE
			else:
				manual_card.get_child(0).modulate = Color.SLATE_GRAY
		else:
			if towers.has(temp_r):
				manual_card.get_child(0).modulate = Color.WHITE
			else:
				manual_card.get_child(0).modulate = Color.SLATE_GRAY



func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.position.x>483:
			return
		if event.is_action_pressed("摄像机放大"):
			scroll_container.scroll_vertical -= 5
		elif event.is_action_pressed("摄像机缩小"):
			scroll_container.scroll_vertical += 5


var if_adding: = false
var if_fold: = true
func _on_wake_button_pressed() -> void:
	update_manul_able()
	if if_adding:
		return
	if if_fold:
		animation_player.play("ease_in")
	else:
		animation_player.play_backwards("ease_in")
	if_fold = !if_fold


func hide_manual()->void:
	if !if_fold:
		animation_player.play_backwards("ease_in")
		if_fold = true


func get_new_card(_name:String)->void:
	if_adding = true

	var cards := grid_container.get_children()
	for card in cards:
		if card.get_child(0)._card_resource.name == _name:
			card.get_child(0).new_card()
			
	#if if_fold:
		#animation_player.play("ease_in")
		#await animation_player.animation_finished
		#if_fold = !if_fold
		#if_adding = false
	update_manul_able()
	if_adding = false
