extends InteractableObject

@export var light_to_switch : Node3D
var toggle : bool = true
@export var light_off_material : StandardMaterial3D
@export var light_on_material : StandardMaterial3D


@onready var mesh_instance_3d_2: MeshInstance3D = %MeshInstance3D2
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _interact():
	if light_to_switch == null:
		return
	if !animation_player.is_playing():
		animation_player.play("toggle")
		toggle = !toggle
		light_to_switch.get_node("Light").visible = toggle
		#light_to_switch.get_node("Mesh").mesh.material.emission_enabled = toggle
		if toggle:
			light_to_switch.get_node("Mesh").material_override = light_on_material
		elif !toggle:
			light_to_switch.get_node("Mesh").material_override = light_off_material

			
			
			
