extends Node3D

@export var flicker_light : bool = false
@export var min_time : float = 10.0
@export var max_time : float = 20.0
@export var min_time_to_flash : float = 0.2
@export var max_time_to_flash : float = 0.4
@export var loop_animation : bool = true
var loop : bool = true

@onready var light: SpotLight3D = %Light
@onready var timer: Timer = %Timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _process(delta: float) -> void:
	#animation_player.play("flash")
	flicker_lights()

func flicker_lights():
	if!flicker_light:
		return
		
	if loop:
		loop = false
		var rng = RandomNumberGenerator.new()
		var random_time = rng.randf_range(min_time, max_time)
		await get_tree().create_timer(random_time).timeout
		animation_player.play("flash")
		if !loop_animation:
			await get_tree().create_timer(2.0).timeout
			animation_player.play("RESET")
			loop = true
		if loop_animation:
			animation_player.get_animation("flash").loop = true
			var random_time2 = rng.randf_range(min_time_to_flash, max_time_to_flash)
			await get_tree().create_timer(random_time2).timeout
			animation_player.play("RESET")
			loop = true
