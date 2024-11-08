extends InteractableObject

var interactable : bool = true
var is_door_open : bool = false
@onready var is_locked = $"../..".is_locked
@onready var key_to_unlock : StaticBody3D = $"../..".key_to_unlock
@onready var door_sound: AudioStreamPlayer3D = $"door sound"
const CREAK_DOOR_04_MONO = preload("res://audio/CREAK_Door_07_mono.wav")
@onready var animation_player: AnimationPlayer = %AnimationPlayer
const DOOR_ENTRANCE_WOOD_CLOSE_STEREO = preload("res://audio/DOOR_Entrance_Wood_Close_stereo.wav")
func _interact():
	if !is_locked and key_to_unlock == null:
		is_locked = false
		if interactable:
			interactable = false
			if is_door_open == false:
				open_door()
			elif is_door_open == true:
				close_door()
	if is_locked:
		if key_to_unlock == null:
			is_locked = false
			if interactable:
				interactable = false
				if is_door_open == false:
					open_door()
				elif is_door_open == true:
					close_door()
		else:
			if !animation_player.is_playing():
				animation_player.play("locked")
func open_door():
	if !animation_player.is_playing():
		animation_player.play("open")
		door_sound.stream = DOOR_ENTRANCE_WOOD_CLOSE_STEREO
		door_sound.pitch_scale = randf_range(0.7, 1.2)
		door_sound.play()
	await animation_player.animation_finished
	interactable = true
	is_door_open = !is_door_open
	var random_chance_to_close_door : float = randf_range(0.0, 1.0)
	print(random_chance_to_close_door)
	if random_chance_to_close_door >= 0.5:
		await get_tree().create_timer(5.0).timeout
		door_sound.stream = CREAK_DOOR_04_MONO
		close_door()
	

func close_door():
	if !animation_player.is_playing():
		animation_player.play("close")
		door_sound.pitch_scale = randf_range(0.7, 1.2)
		door_sound.play()
	await animation_player.animation_finished
	interactable = true
	is_door_open = !is_door_open
