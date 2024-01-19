extends CanvasLayer

func updateScore(points: int):
	$ScoreLable.text = str(points)

func _on_tile_game_map_add_scorce(points:int):
	updateScore(points)
