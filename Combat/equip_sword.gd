extends EquipObject

@export var damage : int = 1
@export var attack_rate := 0.7
var last_attack_time : float

@onready var hit_collider: Area3D = %HitCollider

func on_primary_use():
	if !can_attack():
		return
	
	last_attack_time = Time.get_unix_time_from_system()
	
	animation_player.stop()
	animation_player.play("attack")

func on_hit():
	var bodies = hit_collider.get_overlapping_bodies()
	for body in bodies:
		if player == body:
			continue
			
		if body.has_node("Health"):
			body.get_node("Health").take_damage(damage)

func can_attack() -> bool:
	return Time.get_unix_time_from_system() - last_attack_time > attack_rate