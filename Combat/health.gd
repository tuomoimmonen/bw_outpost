class_name Health extends Node

signal on_change(current : int, max : int)
signal on_take_damage()
signal on_die()
signal ai_is_hit

enum PostDeath {DestroyNode, RestartScene, PlayDeathAnim} #what happens after death

var current : int #health
@export var max : int = 5
@export var post_death_action : PostDeath
@export var drop_on_death : PackedScene
var anim_state: AnimationNodeStateMachinePlayback

func _ready() -> void:
	current = max
	
func take_damage(amount : int):
	current -= amount
	on_change.emit(current, max)
	on_take_damage.emit()
	ai_is_hit.emit()
	if current <= 0:
		die()

func die():
	on_die.emit()
	
	if drop_on_death != null:
		var drop = drop_on_death.instantiate()
		get_node("/root/").add_child(drop)
		drop.position = get_parent().position + Vector3(0,0.5,0)
	
	if post_death_action == PostDeath.DestroyNode:
		get_parent().queue_free()
	elif post_death_action == PostDeath.RestartScene:
		get_tree().reload_current_scene()
	elif post_death_action == PostDeath.PlayDeathAnim:
		get_parent().anim_state.travel("death")

func heal(amount : int):
	current += amount
	if current > max:
		current = max
	
	on_change.emit(current)
