extends InteractableObject

@export var new_prompt_text: String
#@onready var game_manager = get_parent().get_parent()
var bonus_objective_complete:bool = false
@export var cat_god : PackedScene
@export var spawn_position: Node3D
@onready var sonar_sound: AudioStreamPlayer3D = %sonar_sound
@onready var timer: Timer = %Timer
@export var time_before_sonar_sound : float = 10.0

func _ready() -> void:
	timer.wait_time = time_before_sonar_sound
	#game_manager.on_player_has_bonus_completed.connect(change_prompt_text)

func _interact():
	if bonus_objective_complete:
		can_interact = false
		spawn_cat_god()
	
func spawn_cat_god():
	var cat_god_to_spawn = cat_god.instantiate()
	add_sibling(cat_god_to_spawn)
	cat_god_to_spawn.position = spawn_position.global_position

func _on_main_on_player_has_bonus_completed() -> void:
	print("bonus")
	bonus_objective_complete = true
	interact_prompt = new_prompt_text
	
func play_sonar_sound() -> void:
	timer.start()
	await timer.timeout
	if !sonar_sound.playing:
		sonar_sound.play()
