extends Node3D

const ZOMBIE_AI = preload("res://AI/zombie_ai.tscn")
@export var time_before_spawning : float = 5.0
@export var spawn_points : Array[Node3D]
@onready var timer: Timer = %Timer

func spawn_zombies() -> void:
	timer.wait_time = time_before_spawning
	timer.start()
	await timer.timeout
	
	for point in spawn_points:
		var zombie_object = ZOMBIE_AI.instantiate()
		add_sibling(zombie_object)
		zombie_object.position = point.global_position
	
