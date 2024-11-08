extends Node3D

@onready var inventory: Inventory = %Inventory
@onready var spot_light_3d: SpotLight3D = %SpotLight3D
@onready var flashlight_2: Node3D = %flashlight2
@onready var flashlight_sound: AudioStreamPlayer3D = $"flashlight sound"

@export var flashlight_item_to_pickup : Item
var picked_up_flashlight : bool = true
var toggle = true

func _process(delta: float) -> void:
	on_give_player_item_callback(null, null)
	if !picked_up_flashlight:
		return
	
	if Input.is_action_just_pressed("flashlight"):
		toggle = !toggle
		flashlight_sound.pitch_scale = randf_range(0.8,1.2)
		flashlight_sound.play()
		spot_light_3d.visible = toggle
		#mesh_instance_3d.visible = toggle
		flashlight_2.visible = toggle

func _ready() -> void:
	pass
	#GlobalSignals.on_give_player_item.connect(on_give_player_item_callback)

func on_give_player_item_callback(item, amount):
	picked_up_flashlight = inventory.get_amount_of_item(flashlight_item_to_pickup) > 0
