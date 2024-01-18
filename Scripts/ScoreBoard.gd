extends CanvasLayer

#@onready var scoreLabel = $"ScoreLable"

var totalPoints: int

func updateScore(points: int):
	
	totalPoints += points
	$ScoreLable.text = str(totalPoints)
	pass


func _on_tile_game_map_add_scorce(points:int):
	updateScore(points)
