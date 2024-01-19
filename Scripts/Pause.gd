extends CanvasLayer

@onready var this = $"."
@onready var options = $"Options"
var isOptions = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://GameScenes/Menu.tscn")


func _on_options_pressed():
	if isOptions:
		this.hide()
		options.show()
	else:
		options.hide()
		this.show()
		
	isOptions = !isOptions

func _on_new_run_button_pressed():
	get_tree().reload_current_scene()
