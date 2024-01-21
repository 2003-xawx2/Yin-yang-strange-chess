extends AudioStreamPlayer2D
class_name random_audio_2D

@export var stream_array:Array[AudioStream]
@export var random_pitch := true
@export var max_pitch : float = 1.1
@export var min_pitch : float = 0.9


func play_random()->void:
	if stream_array == null or stream_array.size() == 0:
		return

	if random_pitch:
		pitch_scale = randf_range(min_pitch,max_pitch)
	else:
		pitch_scale = 1

	stream = stream_array.pick_random()
	play()
