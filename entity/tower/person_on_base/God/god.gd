extends basic_base


@onready var attack_timer: Timer = $AttackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_attack_timer_timeout() -> void:
	animation_player.play("attack")
	animation_player.queue("idle")


