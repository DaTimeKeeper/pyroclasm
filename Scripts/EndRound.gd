extends CanvasLayer

func _on_new_run_button_pressed():
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/MainMenu.tscn")
