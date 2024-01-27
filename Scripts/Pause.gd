extends CanvasLayer

var options = preload("res://GameScenes/Options.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/MainMenu.tscn")

func _on_new_run_button_pressed():
	get_tree().reload_current_scene()


func _on_continue_pressed():
	$".".hide()
	Engine.time_scale = 1
