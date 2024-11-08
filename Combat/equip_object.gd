class_name EquipObject extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var player : PlayerController

func on_primary_use():
	pass

func on_secondary_use():
	pass

func _input(event: InputEvent) -> void:
	if !player.can_move:
		return
	if event is InputEventMouseButton and event.pressed and player.get_node("Inventory/InventoryWindow").visible == false:
		if event.button_index == 1:
			on_primary_use()
		elif event.button_index == 2:
			on_secondary_use()
