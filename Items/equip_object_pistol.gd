extends EquipObject

@export var damage := 1
@export var fire_rate := 0.7
@export var ammo : int = 7
var last_fire_time : float
@onready var gun_sound: AudioStreamPlayer3D = %gun_sound
@onready var ammo_text: Label = %ammo_text
@onready var empty_gun_sound: AudioStreamPlayer3D = %empty_gun_sound

@onready var gun_ray: RayCast3D = %GunRay
@onready var big_crosshair: TextureRect = %BigCrosshair

const GUN_HIT_PARTICLES = preload("res://gun_hit_particles.tscn")
const BLOOD_PARTICLES = preload("res://blood_particles.tscn")
const BLOOD_DECAL = preload("res://blood_decal.tscn")

func _ready() -> void:
	ammo_text.text = "Ammo: " + str(ammo)

func can_attack() -> bool:
	return Time.get_unix_time_from_system() - last_fire_time > fire_rate and ammo > 0

func on_primary_use():
	if !can_attack():
		if !empty_gun_sound.playing:
			empty_gun_sound.play()
		return
	
	last_fire_time = Time.get_unix_time_from_system()
	
	if !animation_player.is_playing():
		animation_player.play("shoot")
		gun_sound.play()
		ammo -= 1
		if ammo < 0:
			ammo = 0
		ammo_text.text = "Ammo: " + str(ammo)
		if gun_ray.is_colliding():
			#show_crosshair_on_hit()
			var hit_position = gun_ray.get_collision_point()
			if gun_ray.get_collider().is_in_group("Enemy"):
				var health = gun_ray.get_collider().get_node("Health")
				var decal_position = gun_ray.get_collider().get_node("decal_spawn")
				spawn_blood_particles(hit_position)
				spawn_blood_decal(decal_position)
				health.take_damage(damage)
			else:
				spawn_hit_particles(hit_position)

func show_crosshair_on_hit():
	big_crosshair.visible = true
	await get_tree().create_timer(0.05).timeout
	big_crosshair.visible = false

func spawn_blood_particles(position):
	var blood_particles = BLOOD_PARTICLES.instantiate()
	get_parent().add_child(blood_particles)
	blood_particles.global_position = position
	blood_particles.look_at(gun_ray.global_position)
	await get_tree().create_timer(0.1).timeout
	blood_particles.emitting = true

func spawn_blood_decal(position : Node3D):
	if position == null:
		return
	await get_tree().create_timer(0.5).timeout
	var blood_decal = BLOOD_DECAL.instantiate()
	get_tree().current_scene.add_child(blood_decal)
	blood_decal.global_position = position.global_position
	
func spawn_hit_particles(position):
	var gun_particles = GUN_HIT_PARTICLES.instantiate()
	add_sibling(gun_particles)
	gun_particles.global_position = position
	gun_particles.look_at(gun_ray.global_position)
	gun_particles.emitting = true
