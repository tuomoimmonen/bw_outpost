extends State

var home_position : Vector3
@export var max_wander_range : float = 6.0
@export var min_wait_time := 1.0
@export var max_wait_time := 5.0
@export var chase_range := 4.0
var is_hit = false

func enter():
	super.enter()
	controller.is_idling = false
	controller.look_at_player = false
	home_position = controller.position
	_new_wander_position()
	
func _new_wander_position():
	var position = home_position + random_offset() * randf_range(0, max_wander_range)
	controller.move_to_position(position)
	#print(position)

func navigation_complete():
	controller.is_idling = true
	var wait_time = randf_range(min_wait_time, max_wait_time)
	if wait_time > max_wait_time * 0.8:
		controller.play_random_sound()
	await get_tree().create_timer(wait_time).timeout
	if not active:
		return
	_new_wander_position()

func update(delta):
	if controller.player_distance < chase_range:
		state_machine.change_state("Chase")


func _on_health_ai_is_hit() -> void:
	chase_range = 100.0
	controller.run_speed = 20.0
	pass # Replace with function body.
