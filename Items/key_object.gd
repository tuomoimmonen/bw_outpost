extends InteractableObject

func _interact():
	print("Pickup key")
	queue_free()
