class_name machine_state
extends Node


var state_time:float


var current_state:int=-1:
	set(v): #current_state被赋值的时候做的操作
		owner.transition_state(current_state,v)
		current_state=v
		state_time=0


func _ready() -> void:
	await owner.ready #等待owner的ready信号
	current_state=0


func _process(delta: float) -> void:
	while true:
		var next:int = owner.get_next_state(current_state)
		if next == current_state:
			break
		current_state=next
	state_time+=delta
	owner.take_physics(current_state,delta)
