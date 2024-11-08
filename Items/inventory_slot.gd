class_name InventorySlot
extends Node

var item: Item
var amount : int
var inventory : Inventory

@onready var icon: TextureRect = %Icon
@onready var amount_text: Label = %"Amount text"
@onready var player: PlayerController = $"../../../.."


func set_item(new_item:Item): #set the item to a slot
	item = new_item
	amount = 1
	
	if item == null:
		icon.visible = false
	else:
		icon.visible = true
		icon.texture = item.icon
	
	update_amount_text()

func add_item(): #increase the item amount
	amount += 1
	update_amount_text()

func remove_item(): #decrease the item amount
	if !item.can_drop:
		return
	
	amount -= 1
	update_amount_text()
	
	if amount == 0:
		if player.get_node("EquipController").current_equip_item == item:
			player.get_node("EquipController").unequip()
		set_item(null)

func update_amount_text():
	if amount <= 1:
		amount_text.text = " "
	else:
		amount_text.text = str(amount)

func _on_mouse_entered() -> void:
	if item == null:
		inventory.info_text.text = ""
	else:
		inventory.info_text.text = item.display_name

func _on_mouse_exited() -> void:
	inventory.info_text.text = ""

func _on_pressed() -> void:
	if item == null:
		return
	var remove_after_use = item._on_use(inventory.get_parent())
	
	if remove_after_use:
		remove_item()

func drop_item():
	if item == null or item.can_drop == false:
		return
	
	var world_item = item.world_item_scene.instantiate()
	add_child(world_item)
	world_item.position = inventory.get_parent().position + Vector3(0, 1.8,0) - inventory.get_parent().basis.z
	remove_item()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			drop_item()
		
