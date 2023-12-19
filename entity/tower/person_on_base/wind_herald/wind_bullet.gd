extends StaticBody2D


@export var speed = 700
var direction:Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(false)


func init(_direction):
	direction = _direction
	if randi_range(0,1)==1:
		$AnimationPlayer.play("attack_1")
	else:
		$AnimationPlayer.play("attack_2")
	set_physics_process(true)


func _physics_process(delta):
	position+=direction.normalized()*speed*delta
	look_at(direction + global_position)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

