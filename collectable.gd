extends InteractableObject
@onready var button_sound: AudioStreamPlayer3D = %button_sound
@export var item_name : String 
@onready var book_text: Label = %book_text
@export var item_description : String
@onready var text_panel: Panel = %TextPanel
signal on_player_reading
signal on_player_stopped_reading

func _ready() -> void:
	text_panel.visible = false
	book_text.text = item_description
	#animation_player.speed_scale = randf_range(0.4, 0.8)
	#animation_player.play("idle")

func _interact():
	can_interact = false
	var item = load("res://Items/Item Data/" + item_name + ".tres")
	GlobalSignals.on_give_player_item.emit(item, 1) #singleton
	text_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	on_player_reading.emit()

func _on_button_pressed() -> void:
	text_panel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	on_player_stopped_reading.emit()
	if !button_sound.playing:
		button_sound.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
