extends Label
@onready var timer:Timer=$"../../TileGameMap/Timer"
@onready var label:Label=$"."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text= ("%.2f" %timer.time_left)
	pass


func _on_timer_timeout():
	pass # Replace with function body.
