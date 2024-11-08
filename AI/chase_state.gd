extends State

@export var lose_interest_range := 10.0
@export var attack_range := 1.2

@export var path_update_rate := 0.1
var last_path_update_time : float

@export var flee_range := 2.0

func enter():
	super.enter()
	controller.is_running = true
	controller.look_at_player = true
	controller.is_idling = false
	#controller.animation_tree.set("parameters/conditions/run", true)

func exit():
	super.exit()
	controller.is_running = false
	controller.is_stopped = true
	controller.look_at_player = false
	#controller.animation_tree.set("parameters/conditions/run", false)


func update(delta):
	var current_time = Time.get_unix_time_from_system()
	
	if current_time - last_path_update_time > path_update_rate:
		last_path_update_time = current_time
		controller.move_to_position(controller.player.position, false)
		
	if controller.player_distance < attack_range:
		state_machine.change_state("Scare")
	
	if controller.player_distance > lose_interest_range:
		state_machine.change_state("Wander")
