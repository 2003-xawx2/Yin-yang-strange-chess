extends CharacterBody2D


@export var default_damage:=2
@export var default_speed:=2000


func _ready():
	visible = false


func start(direction:Vector2 , speed:float = default_speed , damage:float = default_damage)->void:
	visible = true
	$HurtBox.damage = damage
	velocity = direction.normalized()*speed
	rotation = direction.angle()
#	$GhostSpawner.start_spawn()


func _physics_process(delta):
	move_and_slide()


func _on_hurt_box_hurt():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
