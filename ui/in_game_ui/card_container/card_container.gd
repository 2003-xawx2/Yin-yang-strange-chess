extends Panel

@onready var basic_tower_panel = $BasicTowerPanel


func set_card(id:int,fail_settle_cool_time:float,success_settle_cool_time:float,\
tower_sprite:Texture,basic_tower:PackedScene,consume:Dictionary,description:String,move_manager:Node)->void:
	basic_tower_panel.id = id
	basic_tower_panel.fail_settle_cool_time = fail_settle_cool_time
	basic_tower_panel.success_settle_cool_time = success_settle_cool_time
	basic_tower_panel.tower_sprite = tower_sprite
	$Sprite2D.texture = tower_sprite
	basic_tower_panel.basic_tower = basic_tower
	basic_tower_panel.move_manager = move_manager
	basic_tower_panel.description = description
	basic_tower_panel.consume = consume


func remove_card()->void:
	remove_child($BasicTowerPanel)
