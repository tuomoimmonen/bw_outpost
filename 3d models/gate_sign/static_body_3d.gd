extends InteractableObject

@onready var button_sound: AudioStreamPlayer3D = %button_sound
@onready var book_text: Label = %book_text
@onready var text_panel: Panel = %TextPanel
@export var item_description : String
signal on_player_reading
signal on_player_stopped_reading

func _ready() -> void:
	text_panel.visible = false
	book_text.text = item_description

func _interact() -> void:
	can_interact = false
	text_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	on_player_reading.emit()

func _on_button_pressed() -> void:
	if !button_sound.playing:
		button_sound.play()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	on_player_stopped_reading.emit()
	can_interact = true
	text_panel.visible = false
