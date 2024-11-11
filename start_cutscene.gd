extends Node3D

@onready var start_animation_player: AnimationPlayer = %start_animation_player

signal start_cutscene
signal end_cutscene
var cutscene_watched = false

func _ready() -> void:
	start_animation()

func start_animation() -> void:
	start_animation_player.play("start_cutscene")

func end_animation() -> void:
	end_cutscene.emit()
	await get_tree().create_timer(0.5).timeout
	destroy_start_cutscene()

func start_animation_signal() -> void:
	start_cutscene.emit()
	
func destroy_start_cutscene() -> void:
	queue_free()
