extends Control


func play():
	get_tree().change_scene_to_file("res://main.tscn")

func quit():
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://settings.tscn")
