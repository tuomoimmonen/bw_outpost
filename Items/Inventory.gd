class_name Inventory extends Node

var slots : Array[InventorySlot]

@onready var inventory_window: Panel = %InventoryWindow
@onready var info_text: Label = %InfoText
@onready var slot_container_grid: GridContainer = %SlotContainerGrid

@export var starter_items: Array[Item]

func _ready() -> void:
	toggle_window(false)
	
	for child in slot_container_grid.get_children():
		slots.append(child)
		child.set_item(null) #sets the button empty
		child.inventory = self #sets the itemslots inventory to this inventory
	
	for item in starter_items:
		add_item(item)
		
	GlobalSignals.on_give_player_item.connect(on_give_player_item)

func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("inventory"):
	#	toggle_window(!inventory_window.visible)

func toggle_window(open : bool):
	inventory_window.visible = open
	
	if open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_give_player_item(item : Item, amount : int): #signal activated
	for i in range(amount):
		add_item(item)

func add_item(item : Item):
	var slot = get_slot_to_add(item)
	
	if slot == null: #if inventory is full
		return
	if slot.item == null:
		slot.set_item(item)
	elif  slot.item == item:
		slot.add_item()
		
func remote_item(item : Item):
	var slot = get_slot_to_remove(item)
	
	if slot == null or slot.item == item:
		return
	
	slot.remove_item()

func get_slot_to_add(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.amount < item.max_stack_size:
			return slot
	
	for slot in slots:
		if slot.item == null:
			return slot
			
	return null #inventory is full

func get_slot_to_remove(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item:
			return slot
		
	return null

func get_amount_of_item(item : Item) -> int:
	var total = 0
	for slot in slots:
		if slot.item == item:
			total += slot.amount
	return total
