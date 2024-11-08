extends State

@export var flee_distance := 6.0

func enter():
	super.enter()
	controller.is_running = true
	flee()

func exit():
	super.exit()
	controller.is_running = false

func flee():
	var player_direction = (controller.position - controller.player.position).normalized()
	var move_position = controller.position + (player_direction * flee_distance)
	controller.move_to_position(move_position)

func navigation_complete():
	await get_tree().create_timer(0.5).timeout #buffer
	state_machine.change_state("Wander")
