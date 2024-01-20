extends TileMap

@export var curPosition: Vector2i

@onready var tileMap: TileMap = $"."

enum TILE_TYPES  {GRASS, BUSH, TRESS}
enum TILE_STATUS {GREEN, BURNING, BURNED, WET}

signal addScorce(points: int)
signal allFireOut(finalScore: int)

var startingFireTile = Vector2i(0,0)
var tilesOnFire      = [startingFireTile]

func doDamage(tilePos: Vector2i):
	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var nextHealth =  tile.get_custom_data("health") - 1
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")

	if nextHealth >= 0 && status < 2:
		if (nextHealth== 0):
			tileMap.set_cell(0, tilePos, 0, Vector2i(status+1, type), nextHealth)
		else:
			tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), nextHealth)

func _on_update_fire_timer_timeout():
	var futureTilesOnFire = []
	var tilesToErase = []
	
	if tilesOnFire.size()==0:
		$updateFireTimer.stop()
		$updateFireTimer.autostart=false
		allFireOut.emit(countTiles())

	for t in tilesOnFire:
		var currentTile: TileData = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue

		var neighbors : Array[Vector2i] = tileMap.get_surrounding_cells(t)

		for n in neighbors:
			var neighborTile: TileData = tileMap.get_cell_tile_data(0, n)
			if !neighborTile || !neighborTile.get_custom_data("burnable"):
				continue

			doDamage(n)
			if tileMap.get_cell_tile_data(0,n).get_custom_data("onFire"):
				futureTilesOnFire.append(n)
				
		doDamage(t)
		currentTile = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue
		if !currentTile.get_custom_data("onFire"):
			tilesToErase.append(t)

	tilesOnFire = tilesOnFire + futureTilesOnFire
	for e in tilesToErase:
		tilesOnFire.erase(e)
		
	addScorce.emit(countTiles())
		 

func countTiles():
	var burnTiles: Array[Vector2i] = []

	for x in range(3):
		burnTiles += tileMap.get_used_cells_by_id(0, 0, Vector2i(2, x)) 

	return burnTiles.size()

