class_name HealthManager
extends ProgressBar

signal die

@export var hit_box:HitBox
@export var max_health:int = 5
 
var current_health:float


func _ready():
	current_health = max_health
	max_value = max_health
	value = max_value


func damage(_damage:int)->void:
	current_health -= _damage
	if current_health <=0:
		current_health = 0
		die.emit()
	value = current_health
