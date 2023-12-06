extends StaticBody2D


const SPEED = 300.0
@onready var ray_cast_2d = $RayCast2D
var sprite:Texture:
	set(value):
		$MagicCard.magic_sprite = value
var magic:PackedScene:
	set(value):
		$MagicCard.magic = value


func _physics_process(delta):
	if !ray_cast_2d.is_colliding():
		position.x-=SPEED*delta


func free_self()->void:
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("disappear")
