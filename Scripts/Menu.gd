extends CanvasLayer

var options = preload("res://GameScenes/Options.tscn")
var instance

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/WorldMain.tscn")


func _on_options_button_pressed():
	instance = options.instantiate()
	add_child(instance)



func _on_quit_button_pressed():
	get_tree().quit()
