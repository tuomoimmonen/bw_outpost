extends Node

@export var evidence_item : Item
@export var cat_item : Item
@export var evidence_to_collect : int = 3
@export var cat_item_to_collect : int = 3

@onready var objective_text: Label = %ObjectiveText
@onready var inventory : Inventory = get_node("Player/Inventory")
@onready var bonus_objective_text: Label = %BonusObjectiveText

signal on_player_has_bonus_completed()
signal on_player_picked_up_strange()
signal on_player_evidence_completed()

func _ready() -> void:
	update_objective_text(evidence_item, 0)
	GlobalSignals.on_give_player_item.connect(update_objective_text)
	GlobalSignals.on_give_player_item.connect(update_bonus_objective_text)
	bonus_objective_text.text = ""

func update_objective_text(item, amount):
	var current = inventory.get_amount_of_item(evidence_item)
	objective_text.text = "Find evidence " + str(current) + "/" + str(evidence_to_collect)
	if current == 3:
		on_player_evidence_completed.emit()
		await get_tree().create_timer(10.0).timeout
		objective_text.text = "Escape to Blackwood outpost gate"

func update_bonus_objective_text(item, amount):
	var current = inventory.get_amount_of_item(cat_item)
	if item == cat_item:
		on_player_picked_up_strange.emit()
	if current == 0:
		return
	bonus_objective_text.text = "Find strange objects " + str(current) + "/" +str(cat_item_to_collect)
	if current == 3:
		await get_tree().create_timer(5.0).timeout
		bonus_objective_text.text = "Investigate the mystery"
		on_player_has_bonus_completed.emit()
	
