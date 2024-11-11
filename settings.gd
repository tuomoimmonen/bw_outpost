extends Control

@onready var volume_slider: HSlider = %volume_slider
@onready var mute_audio_check: CheckBox = %mute_audio_check
@onready var resolutions: OptionButton = %resolutions
@onready var window_mode: OptionButton = %window_mode
@onready var button_sound: AudioStreamPlayer = %button_sound

func _ready() -> void:
	load_settings()

func _on_volume_slider_value_changed(value: float) -> void:
	play_button_sound()
	AudioServer.set_bus_volume_db(0, value)

func _on_check_box_toggled(toggled_on: bool) -> void:
	play_button_sound()
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			play_button_sound()
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			play_button_sound()
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			play_button_sound()
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			play_button_sound()
			DisplayServer.window_set_size(Vector2i(320, 240))


func _on_button_pressed() -> void:
	play_button_sound()
	get_tree().paused = false
	save_settings()
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
		#get_tree().change_scene_to_file("res://main_menu.tscn")

func save_settings() -> void:
	var saved_settings : SavedSettings = SavedSettings.new()
	
	saved_settings.master_volume = volume_slider.value
	saved_settings.master_toggle = mute_audio_check.button_pressed
	saved_settings.selected_resolution = resolutions.selected
	saved_settings.selected_window_mode = window_mode.selected
	
	#saved_settings.save_settings()
	ResourceSaver.save(saved_settings, "user://savedsettings.tres")

func load_settings() -> void:
	if ResourceLoader.exists("user://savedsettings.tres"):
		var saved_settings : SavedSettings = load("user://savedsettings.tres") as SavedSettings
		volume_slider.value = saved_settings.master_volume
		mute_audio_check.button_pressed = saved_settings.master_toggle
		resolutions.selected = saved_settings.selected_resolution
		window_mode.selected = saved_settings.selected_window_mode
	else:
		volume_slider.value = 0.8
		mute_audio_check.button_pressed = false
		resolutions.selected = 3
		window_mode.selected = 0
	#volume_slider.value = Settings.master_volume
	#mute_audio_check.button_pressed = Settings.master_toggle


func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0:
			play_button_sound()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			play_button_sound()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_exit_game_button_pressed() -> void:
	play_button_sound()
	get_tree().paused = false
	save_settings()
	visible = false
	get_tree().quit()

func _on_main_menu_button_pressed() -> void:
	play_button_sound()
	get_tree().paused = false
	save_settings()
	visible = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func play_button_sound() -> void:
	if !button_sound.playing:
		button_sound.pitch_scale = randf_range(0.8,1.2)
		button_sound.play()
