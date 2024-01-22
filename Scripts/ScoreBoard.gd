extends CanvasLayer

func _on_tile_game_map_set_scorce(points):
	$ScoreLable.text = str(points)
