extends TileMap

@export var curPosition: Vector2i

@onready var tileMap: TileMap = $"."

enum TILE_TYPES  {GRASS, BUSH, TRESS}
enum TILE_STATUS {GREEN, BURNING, BURNED, WET}

var startingFireTile = Vector2i(1,1)
var tilesOnFire  = [startingFireTile]

func _process(delta):
	pass
		
func doDamage(tilePos: Vector2i):
	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var health = tile.get_custom_data("health")
	var nextHealth =  health - 1
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")
	var burnable = tile.get_custom_data("burnable")

	if nextHealth >= 0 && status < 2:
		if (nextHealth== 0):
			tileMap.set_cell(0, tilePos, 0, Vector2i(status+1, type), nextHealth)
		else:
			tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), health)


func _on_timer_timeout():

	var futureTilesOnFire = []
	var tilesToErase = []

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
		if !tileMap.get_cell_tile_data(0,t).get_custom_data("onFire"):
			tilesToErase.append(t)

	tilesOnFire = tilesOnFire + futureTilesOnFire
	for e in tilesToErase:
		tilesOnFire.erase(e)
