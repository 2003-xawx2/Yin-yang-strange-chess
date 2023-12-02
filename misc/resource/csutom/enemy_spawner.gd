extends Resource
class_name enemy_spawner


@export var spawn_position:int
@export var end_position:int
@export_category("spawn_enemy")
@export var enemy_type:Global.EnemyType
@export var enemy_faction:Global.Faction
@export_category("spawn_time")
@export var showing_time:float
@export var show_interval:float
@export var show_amounts:int
