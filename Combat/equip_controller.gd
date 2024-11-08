extends Node

@onready var equip_origin: Node3D = %EquipOrigin
var current_equip : EquipObject
var current_equip_item : EquipItem

@onready var flashlight_origin: Node3D = %FlashlightOrigin # New node for flashlight

func equip(item : EquipItem):
	if current_equip_item == item:
		unequip()
		return
	
	unequip()
	var obj = item.equip_scene.instantiate()
	equip_origin.add_child(obj)
	current_equip = obj
	current_equip.player = get_parent()
	current_equip_item = item

func unequip():
	if current_equip == null:
		return
	
	current_equip.queue_free()
	current_equip = null
	current_equip_item = null

func _ready() -> void:
	equip(preload("res://Items/Item Data/Pistol.tres"))
	pass
