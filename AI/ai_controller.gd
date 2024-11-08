class_name AIController
extends CharacterBody3D

@export var walk_speed := 2.0
@export var run_speed := 3.5
@export var acceleration := 20.0
var is_running := false
var is_stopped := false
var is_idling : bool
var look_at_player : bool = false
var move_direction : Vector3
var target_y_rotation : float
var player_distance: float
@export var attack_distance := 1.5
#@onready var growl_sound: AudioStreamPlayer3D = %growl_sound
@onready var animation_player: AnimationPlayer = %AnimationPlayer_mesh
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = %NavigationAgent3D
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var anim_state : AnimationNodeStateMachinePlayback

var can_move : bool = true

@onready var random_sound: AudioStreamPlayer3D = %random_sound
@export var random_sounds : Array[AudioStream]
@export var walk_audio : AudioStream
@export var run_audio : AudioStream
@export var attack_audio : AudioStream
@export var eat_audio : AudioStream
@onready var footstep_sound: AudioStreamPlayer3D = %footstep_sound
@onready var eat_sound: AudioStreamPlayer3D = %eat_sound

func _ready() -> void:
	anim_state = animation_tree["parameters/playback"]
	
	#print(player.position)

func _process(_delta: float) -> void:
	if !can_move:
		return
	if player != null:
		player_distance = position.distance_to(player.position)
	
func _physics_process(delta: float) -> void:
	if !can_move:
		return
	var target_position = navigation_agent_3d.get_next_path_position()
	var current_speed = walk_speed
	
	# Gravity
	if is_on_floor():
		velocity.y -= gravity * delta
	
	# Move direction
	move_direction = position.direction_to(target_position)
	move_direction.y = 0.0
	
	# Running
	if is_running:
		#footstep_sound.stream = run_audio
		current_speed = run_speed
	#if current_speed == walk_speed:
		#footstep_sound.stream = walk_audio
		
	if navigation_agent_3d.is_navigation_finished() or is_stopped:
		move_direction = Vector3.ZERO
	
	is_idling = move_direction == Vector3.ZERO
	
	var target_velocity = move_direction * current_speed
	
	velocity.x = lerp(move_direction.x, target_velocity.x, acceleration * delta) 
	velocity.z = lerp(move_direction.z, target_velocity.z, acceleration * delta)
	
	animation_tree.set("parameters/conditions/walk", !is_idling and !is_running)
	animation_tree.set("parameters/conditions/idle", is_idling)
	animation_tree.set("parameters/conditions/run", is_running)
		
	move_and_slide()
	
	# Rotation
	if look_at_player:
		var player_direction = player.position - position
		target_y_rotation = atan2(player_direction.x, player_direction.z)
	elif velocity.length() > 0: #if not looking at player but wandering
		target_y_rotation = atan2(velocity.x, velocity.z)
	
	rotation.y = lerp_angle(rotation.y, target_y_rotation, 2.0 * delta)
	
	#print(move_direction)
	
func move_to_position(to_position : Vector3, adjust_position : bool = true):
	if not navigation_agent_3d:
		navigation_agent_3d = get_node(^"%NavigationAgent3D")
	
	is_stopped = false
	is_idling = false
	# Position snapping on navmesh
	if adjust_position:
		var map = get_world_3d().navigation_map
		var adjusted_pos = NavigationServer3D.map_get_closest_point(map, to_position) #expensive calculation
		navigation_agent_3d.target_position = adjusted_pos
	else:
		navigation_agent_3d.target_position = to_position

func play_walk_sound() -> void:
	print("walk audio")
	footstep_sound.stream = walk_audio
	footstep_sound.pitch_scale = randf_range(0.8, 1.1)
	if !footstep_sound.playing:
		footstep_sound.play()

func play_run_audio() -> void:
	print("run")
	footstep_sound.stream = run_audio
	footstep_sound.pitch_scale = randf_range(0.8, 1.1)
	if !footstep_sound.playing:
		footstep_sound.play()

func play_attack_sound() -> void:
	footstep_sound.stream = attack_audio
	if !footstep_sound.playing:
		footstep_sound.play()
	pass

func play_eat_audio() -> void:
	eat_sound.pitch_scale = randf_range(0.95, 1.05)
	if !eat_sound.playing:
		eat_sound.play()
		

func play_random_sound() -> void:
	if !random_sound.playing:
		random_sound.stream = random_sounds.pick_random()
		random_sound.pitch_scale = randf_range(0.9,1.2)
		random_sound.play()

func death() -> void:
	can_move = false
