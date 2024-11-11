extends InteractableObject

@onready var button_sound: AudioStreamPlayer3D = %button_sound
@onready var text_panel: Panel = %TextPanel
signal on_player_reading
signal on_player_stopped_reading

func _ready() -> void:
	text_panel.visible = false

func _interact() -> void:
	text_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	on_player_reading.emit()

func _on_button_pressed() -> void:
	if !button_sound.playing:
		button_sound.play()
	text_panel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	on_player_stopped_reading.emit()
