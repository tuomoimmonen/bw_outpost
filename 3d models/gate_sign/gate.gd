extends InteractableObject

var interactable : bool = true
var is_door_open : bool = false

@onready var gate_staticbody: StaticBody3D = %gate_staticbody
@onready var gate_staticbody_2: StaticBody3D = %gate_staticbody2
@onready var gate_sound: AudioStreamPlayer3D = %gate_sound

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _interact() -> void:
	if interactable:
		can_interact = false
		interactable = false
		if is_door_open:
			close_door()
		else:
			open_door()

func close_door() -> void:
	if !animation_player.is_playing():
		if !gate_sound.playing:
			gate_sound.play()
		animation_player.play("close_gate")
		await animation_player.animation_finished
		
		gate_staticbody.is_door_open = false
		gate_staticbody_2.is_door_open = false
		interactable = true
		can_interact = true

func open_door() -> void:
		if !animation_player.is_playing():
			if !gate_sound.playing:
				gate_sound.play()
			animation_player.play("open_gate")
			await animation_player.animation_finished
			#is_door_open = true
			gate_staticbody.is_door_open = true
			gate_staticbody_2.is_door_open = true
			interactable = true
			can_interact = true
