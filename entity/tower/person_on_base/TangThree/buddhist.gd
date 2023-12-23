extends basic_bullet

var _rotation:float
var tween:Tween
var current_speed:Vector2
var zangArray := [
	"དེང",
	"དེདེོཀོ",
	"ཨཔར",
	"འལཟམ",
	"ངཨིོཝེ",
	"ཇདཝིུཧར",
	"ཡེར༤༨",
	"༧ཝཧ༤",
]

func _ready() -> void:
	scale = Vector2.ZERO


func init(_direction:Vector2)->void:
	super.init(_direction)
	tween=create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"scale",Vector2.ONE,1)

	current_speed = direction.normalized() * speed
	#animation_player.play("attack")
	$Label.text = zangArray.pick_random()
	_rotation = randf_range(-PI/6,PI/6)


func _physics_process(delta: float) -> void:
	current_speed *= 1.015999
	current_speed = current_speed.rotated(_rotation*delta*5)
	position += current_speed*delta
	look_at(global_position+current_speed)



func _on_timer_timeout() -> void:
	if tween:return
	tween=create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"scale",Vector2.ZERO,.2)
	tween.tween_callback(queue_free)
