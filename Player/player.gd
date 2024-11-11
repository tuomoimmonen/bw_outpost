class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var max_speed := 4.0
@export var acceleration := 20.0
@export var deceleration := 10.0
@export var air_acceleration := 5.0
@export var jump_force := 5.0
@export var gravity_modifier := 1.5
@export var max_run_speed := 8.0
var target_speed : float
var is_running := false
@onready var footstep: AudioStreamPlayer3D = %footstep
@export var run_audio_inside: AudioStream
@export var run_audio_outside: AudioStream
@export var walk_audio_inside: AudioStream
@export var walk_audio_outside: AudioStream
@onready var sprint_slider: HSlider = %sprint_slider
@export var sprint_drain_speed : float = 0.2
@export var sprint_recovery_speed : float = 0.1
@onready var forest_ambience: AudioStreamPlayer3D = $"AmbienceController/Forest ambience"
@onready var house_ambience: AudioStreamPlayer3D = $"AmbienceController/House ambience"
var is_inside : bool = false
var can_move : bool = true
var can_run : bool = true
@onready var breathing_sound: AudioStreamPlayer3D = %breathing_sound

@export_group("Camera")
@export var look_sensitivity := 0.005
@onready var settings: Control = %settings

@export_group("HeadBob")
@export var bob_freq := 2.0
@export var bob_amplitude := 0.08
var t_bob := 0.0

@export_group("WeaponSway")
@export var weapon_holder : Node3D
@onready var flashlight_origin: Node3D = %FlashlightOrigin
@export var weapon_sway_amount : float = 5.0
@export var weapon_rotation_amount : float = 1.0
@export var camera_rotation_amount := 1.0
var weapon_default_holder_position : Vector3
var flashlight_default_holder_position : Vector3

var mouse_input : Vector2

@onready var camera: Camera3D = %Camera3D
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier
@onready var head: Node3D = %Head
@onready var texture_rect_2: TextureRect = %TextureRect2


func camera_tilt(input_x, delta):
	if camera:
		head.rotation.z = lerp(head.rotation.z, -input_x * camera_rotation_amount, 10 * delta)

func weapon_tilt(input_x, delta):
	if weapon_holder:
		weapon_holder.rotation.z = lerp(weapon_holder.rotation.z, -input_x * weapon_rotation_amount, 10 * delta)
		flashlight_origin.rotation.z = lerp(weapon_holder.rotation.z, -input_x * weapon_rotation_amount * 0.2, 10 * delta)
		

func weapon_sway(delta):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, mouse_input.y * weapon_rotation_amount, 10 * delta)
	flashlight_origin.rotation.x = lerp(weapon_holder.rotation.x, mouse_input.y * weapon_rotation_amount * 0.2, 10 * delta)
	
	weapon_holder.rotation.y = lerp(weapon_holder.rotation.y, mouse_input.x * weapon_rotation_amount, 10 * delta)
	flashlight_origin.rotation.y = lerp(weapon_holder.rotation.y, mouse_input.x * weapon_rotation_amount * 0.2, 10 * delta)
	

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	weapon_default_holder_position = weapon_holder.position
	flashlight_default_holder_position = weapon_holder.position
	sprint_slider.value = sprint_slider.max_value
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		settings.visible = true
		
	if !can_move:
		return
	# DEBUG BUTTON
	#if Input.is_action_just_pressed("ui_cancel"):
	#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if sprint_slider.value == sprint_slider.min_value:
		if !breathing_sound.playing:
			breathing_sound.pitch_scale = randf_range(0.85, 1.05)
			breathing_sound.play()
	elif sprint_slider.value >= sprint_slider.max_value * 0.5:
		breathing_sound.stop()
	
	if is_running and sprint_slider.value > sprint_slider.min_value and can_run and target_speed == max_run_speed:
		sprint_slider.visible = true
		sprint_slider.value -= sprint_drain_speed * _delta
	else:
		sprint_slider.value += sprint_recovery_speed * _delta
		can_run = false
		sprint_slider.visible = true
		if sprint_slider.value > sprint_slider.max_value * 0.3:
			can_run = true
			sprint_slider.visible = false

			

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	
	# Move input
	var move_input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction := (head.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	
	# Running
	target_speed = max_speed
	if can_run:
		is_running = Input.is_action_pressed("run")
		if is_running:
			target_speed = max_run_speed
	
	var current_smoothing = acceleration
	if not is_on_floor():
		current_smoothing = air_acceleration
	elif not move_direction:
		current_smoothing = deceleration
	
	var target_velocity = move_direction * target_speed

	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)
	
	# HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor()) #prevent bobbing in air
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()
	camera_tilt(move_input.x, delta)
	weapon_tilt(move_input.x, delta)
	weapon_sway(delta)
	weapon_bob(t_bob, delta)
	play_footstep_sounds(target_velocity)
	
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amplitude
	return pos
	
func weapon_bob(vel : float, delta):
	if weapon_holder:
		var bob_amount := 0.01
		var bob_freq := 3.5
		weapon_holder.position.y = sin(vel * bob_freq) * bob_amount
		flashlight_origin.position.y = sin(vel * bob_freq) * bob_amount * 0.5
		
		weapon_holder.position.x = sin(vel * bob_freq) * bob_amount
		flashlight_origin.position.x = sin(vel * bob_freq) * bob_amount * 0.5
		
	else: 
		weapon_holder.position.y = lerp(weapon_holder.position.y, weapon_default_holder_position.y,2 * delta)
		flashlight_origin.position.y = lerp(weapon_holder.position.y, weapon_default_holder_position.y,2 * delta)
		
		weapon_holder.position.x = lerp(weapon_holder.position.x, weapon_default_holder_position.x,2 * delta)
		flashlight_origin.position.x = lerp(weapon_holder.position.x, weapon_default_holder_position.x,2 * delta)
		
			
func _unhandled_input(event: InputEvent) -> void:
	if !can_move:
		return
	if event is InputEventMouseMotion:
		# Camera look
		head.rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5) #radians
		mouse_input = event.relative

func play_footstep_sounds(target_velocity: Vector3) -> void:
	if is_on_floor() and target_velocity != Vector3.ZERO:
		if !footstep.playing:
			if is_running and can_run:
				if is_inside:
					footstep.stream = run_audio_inside
				elif !is_inside:
					footstep.stream = run_audio_outside
			else:
				if is_inside:
					footstep.stream = walk_audio_inside
				elif !is_inside:
					footstep.stream = walk_audio_outside
			footstep.pitch_scale = randf_range(0.8, 1.2)
			footstep.play()
	elif footstep.playing:
		footstep.stop()

func _on_forest_ambience_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		is_inside = false
		if !forest_ambience.playing:
			forest_ambience.pitch_scale = randf_range(0.95, 1.05)
			house_ambience.stop()
			forest_ambience.play()


func _on_house_ambience_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		is_inside = true
		if !house_ambience.playing:
			house_ambience.pitch_scale = randf_range(0.95, 1.05)
			forest_ambience.stop()
			house_ambience.play()


func _on_open_book_object_on_player_reading() -> void:
	can_move = false

func _on_open_book_object_on_player_stopped_reading() -> void:
	can_move = true
