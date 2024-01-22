extends TileMap

@onready var tileMap: TileMap = $"."

signal addScorce(points: int)
signal allFireOut(finalScore: int)

func _on_update_fire_timer_timeout():

	var tilesOnFire: Array[Vector2i] = getTilesOnFire()

	for t in tilesOnFire:
		if tileMap.get_cell_tile_data(0, t) != null:
			burnNeigbors(t)
			doDamage(t)
			if tileMap.get_cell_tile_data(0, t).get_custom_data("status") == 2:
				tileMap.erase_cell(1, t)
		
	addScorce.emit(countBurnedTiles()) #update Score

func doDamage(tilePos: Vector2i):

	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var nextHealth     = tile.get_custom_data("health") - 1
	var type           = tile.get_custom_data("type")
	var status         = tile.get_custom_data("status")

	if status < 2:
		if (nextHealth <= 0):
			tileMap.set_cell(0, tilePos, 0, Vector2i(status + 1, type))
			if status + 1 == 1:
				setOnfire(tilePos)
		else:
			tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), nextHealth)

	

func countBurnedTiles():

	var burnTiles: Array[Vector2i] = []

	for x in range(3):
		burnTiles += tileMap.get_used_cells_by_id(0, 0, Vector2i(2, x)) 

	return burnTiles.size()

func getTilesOnFire():

	var tilesburning : Array[Vector2i] = tileMap.get_used_cells_by_id(1, 1, Vector2i(0, 0))

	if !tilesburning:
		allFireOut.emit(countBurnedTiles())
		pass
	
	return tilesburning

func checkOnfire(tilePos: Vector2i):

	if(tileMap.get_cell_tile_data(1, tilePos)):
		return true
	else:
		return false

func setOnfire(tilePos: Vector2i):

	tileMap.set_cell(1, tilePos, 1, Vector2i(0, 0))

func burnNeigbors(tilePos: Vector2i):

	var neighbors : Array[Vector2i] = tileMap.get_surrounding_cells(tilePos)

	for n in neighbors:

		var neighborTile: TileData = tileMap.get_cell_tile_data(0, n)
		if neighborTile != null: # TODO: add check if tile is on fire
			doDamage(n)
				
		

		


