extends AudioStreamPlayer3D

@export var time_between_horn : float = 2.0
var timer : float
var player_complete : bool = false

func _process(delta: float) -> void:
	if !player_complete:
		return
	
	timer += delta
	if timer >= time_between_horn:
		play_horn_audio()
		time_between_horn = randf_range(time_between_horn, time_between_horn+1.0)
		timer = 0.0
	
func _on_main_on_player_evidence_completed() -> void:
	player_complete = true

func play_horn_audio() -> void:
	if !playing:
		pitch_scale = randf_range(0.8, 1.0)
		play()
