extends Label

@export var score=0

@onready var scoreLabel: Label = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	scoreLabel.text = str(score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateScore(newScore):
	score=newScore
	scoreLabel.text=str(score)
	
