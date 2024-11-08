extends Camera3D

@onready var camera_3d: Node3D = %Camera3D

func _process(delta: float) -> void:
	global_transform = camera_3d.global_transform
	global_rotation = camera_3d.global_rotation
