extends Control

@export var scene_name : String
@onready var timer: Timer = %Timer
@onready var color_fader: ColorRect = %ColorFader
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(color_fader, "modulate:a", 0.0, 3.0)
	await get_tree().create_timer(1.0).timeout
	animation_player.play("end")
	await animation_player.animation_finished
	show_ui()


func _on_mainmenu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func show_ui() -> void:
	await get_tree().create_timer(0.5).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
