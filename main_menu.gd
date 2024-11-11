extends Control

const MAIN = preload("res://main.tscn")
@onready var settings: Control = %settings
@onready var controls_ui: MarginContainer = %"Controls UI"
@onready var button_sound: AudioStreamPlayer = %button_sound

func _ready() -> void:
	settings.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func play():
	play_button_sound()
	get_tree().change_scene_to_packed(MAIN)

func quit():
	play_button_sound()
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	play_button_sound()
	controls_ui.visible = false
	settings.visible = true
	#get_tree().change_scene_to_file("res://settings.tscn")


func _on_controls_button_pressed() -> void:
	play_button_sound()
	controls_ui.visible = !controls_ui.visible

func play_button_sound() -> void:
	if !button_sound.playing:
		button_sound.pitch_scale = randf_range(0.8,1.2)
		button_sound.play()
