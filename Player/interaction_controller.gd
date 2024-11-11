extends RayCast3D

@onready var interact_text: Label = %InteractText
@onready var interact_sound: AudioStreamPlayer3D = %interact_sound

func _process(_delta: float) -> void:
	var object = get_collider()
	interact_text.text = ""
	
	if object and object is InteractableObject:
		if object.can_interact == false:
			return
		
		interact_text.text = "[E] " + object.interact_prompt
		if Input.is_action_just_pressed("interact"):
			interact_sound.pitch_scale = randf_range(0.8, 1.2)
			interact_sound.play()
			object._interact()
	
	
	
