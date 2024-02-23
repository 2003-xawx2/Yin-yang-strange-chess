extends CharacterBody2D


var if_has_settle_place = true
var a_tween:Tween
@onready var graphic: Node2D = $Graphic
@onready var disappear_timer: Timer = $DisappearTimer
@onready var sprites:Array[Sprite2D] = [$Graphic/Top,$Graphic/Middle,$Graphic/Down]

@export var scale_position_y = 203
@export var scale_scale:Vector2 = Vector2.ONE * 2.66


func _ready():
	set_alpha(0)
	$CollisionShape2D.disabled = true

func try_to_settle()->void:
	set_alpha(.4)
	$CollisionShape2D.disabled = false


func settle_fail()->void:
	change_a(0)
	a_tween.tween_callback(queue_free)


func settle_success()->void:
	change_a(1)
	disappear_timer.start()
	var tween:=create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel()
	tween.tween_property(self,"global_position:y",scale_position_y,.7)
	tween.tween_property(self,"scale",scale_scale,.7)
	tween.chain()


func change_a(a:float)->void:
	if a_tween and a_tween.is_running():
		a_tween.kill()
	a_tween = create_tween().set_ease(Tween.EASE_OUT)
	a_tween.tween_method(set_alpha,get_alpha(),a,.4)


func _on_disappear_timer_timeout() -> void:
	settle_fail()


func set_alpha(a:float)->void:
	for sprite in sprites:
		sprite.material.set_shader_parameter("alpha",a)


func get_alpha()->float:
	return sprites[0].material.get_shader_parameter("alpha")
