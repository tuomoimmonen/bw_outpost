class_name Item extends Resource

@export var display_name : String
@export var icon : Texture2D #in the ui
@export var max_stack_size : int = 12
@export var world_item_scene : PackedScene #instantiated object in the world
@export var can_drop : bool = true


func _on_use(_player) -> bool:
	#print("use")
	return false
