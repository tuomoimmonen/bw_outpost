extends Decal

@export var time_before_destroy:float = 10.0
@onready var timer: Timer = %Timer

func _ready() -> void:
	timer.wait_time = time_before_destroy
	destroy_decal()
	
func destroy_decal() -> void:
	await timer.timeout
	queue_free()
