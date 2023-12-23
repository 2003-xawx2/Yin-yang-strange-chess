extends StaticBody2D
class_name basic_bullet

@onready var animation_player: AnimationPlayer = $Graphic/AnimationPlayer
@onready var graphic: Node2D = $Graphic

@export var speed = 700
var direction:Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(false)


func init(_direction):
	direction = _direction
	set_physics_process(true)


func basic_process(delta:float)->void:
	position+=direction.normalized()*speed*delta
	look_at(direction + global_position)



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
