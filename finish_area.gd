extends Area3D

@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var color_rect: ColorRect = %ColorRect
@onready var evidence_finish_animationplayer: AnimationPlayer = %evidence_finish_animationplayer

func _on_main_on_player_evidence_completed() -> void:
	collision_shape_3d.disabled = false

func _on_body_entered(body: Node3D) -> void:
	if body == get_node("/root/" + get_tree().current_scene.name + "/Player"):
		var player = get_node("/root/" + get_tree().current_scene.name + "/Player") as PlayerController
		player.can_move = false
		evidence_finish_animationplayer.play("evidence_finish")
		await get_tree().create_timer(2.0).timeout
		var tween := create_tween()
		tween.tween_property(color_rect, "modulate:a", 1.0, 13.0)
		await get_tree().create_timer(15.0).timeout
		get_tree().change_scene_to_file("res://evidence_win_screen.tscn")
		#print("win")
		
