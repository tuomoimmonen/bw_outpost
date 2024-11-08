extends State

@onready var scare_camera: Camera3D = %ScareCamera
@export var scare_timer: float = 5
#@onready var zombie_anim: AnimationPlayer = $"../../zfemale/AnimationPlayer"
@onready var scare_animationplayer: AnimationPlayer = %scare_animationplayer
@export var is_god : bool = false

func enter():
	super.enter()
	controller.is_stopped = true
	controller.look_at_player = true
	if !is_god:
		show_scare()
	else:
		show_true_ending()
	
func exit():
	pass

func show_scare():
	controller.player.visible = false
	scare_camera.current = true
	controller.anim_state.travel("attack")
	scare_animationplayer.play("scare")
	await get_tree().create_timer(scare_timer).timeout
	get_tree().change_scene_to_file("res://death_screen.tscn")

func show_true_ending():
	controller.player.visible = false
	scare_camera.current = true
	controller.anim_state.travel("attack")
	scare_animationplayer.play("scare")
	await get_tree().create_timer(scare_timer).timeout
	get_tree().change_scene_to_file("res://true_ending_scene.tscn")
