class_name SavedSettings
extends Resource

const SAVE_SETTINGS_PATH := "user://savedsettings.tres"

@export var master_volume: float
@export var master_toggle: bool
@export var selected_resolution: int
@export var selected_window_mode: int

func save_settings() -> void:
	ResourceSaver.save(self, SAVE_SETTINGS_PATH)
	
static func load_save_settings() -> Resource:
	if ResourceLoader.exists(SAVE_SETTINGS_PATH):
		return load(SAVE_SETTINGS_PATH)
	return null
