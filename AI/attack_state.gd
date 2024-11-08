extends State

@export var damage : int = 1
@export var attack_rate : float = 1.5
var last_attack_time : float
@export var attack_range := 1.2

func enter():
	super.enter()
	controller.is_stopped = true
	controller.look_at_player = true

func exit():
	pass
	
func update(delta):
	if can_attack():
		attack()
	
	if controller.player_distance > attack_range:
		state_machine.change_state("Chase")

func attack():
	last_attack_time = Time.get_unix_time_from_system()
	controller.player.get_node("Health").take_damage(damage)

func can_attack() -> bool:
	return Time.get_unix_time_from_system() - last_attack_time > attack_rate
