extends Control

var music_index:int
var effect_index:int

const title_screen = "res://ui/title_screen/title_screen.tscn"

func _ready() -> void:
	music_index = AudioServer.get_bus_index("music")
	effect_index = AudioServer.get_bus_index("effect")
	$VBoxContainer/SoundEffect/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(effect_index))
	$VBoxContainer/MusicSound/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	

func _on_back_pressed() -> void:
	Transition.change_to(title_screen)



func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_index,linear_to_db(value))


func _on_effect_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(effect_index,linear_to_db(value))


func _on_max_screen_pressed() -> void:
	var mode := DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

