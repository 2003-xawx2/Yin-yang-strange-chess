extends Label

@onready var second_timer: Timer = $SecondTimer
@export var all_seconds:int = 5
@export var all_minutes:int = 0

var seconds:=0
var minutes:=0


func _ready() -> void:
	Global.start_game.connect(func()->void:
		second_timer.start())
	seconds = all_seconds
	minutes = all_minutes
	update_text()


func _on_second_timer_timeout() -> void:
	seconds -= 1
	if minutes == 0 and seconds == -1:
		Global.emit_victory()
		second_timer.stop()
		return
	if seconds == -1:
		seconds = 59
		minutes -= 1
	update_text()


func update_text()->void:
	text = "%02d" % minutes +":"+ "%02d" % seconds  
















