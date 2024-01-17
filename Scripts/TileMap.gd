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
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")

	if health >= 0 && status != 2:
		tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), health)
		if (health == 0):
			changeStatus(tilePos)

		return true
	else:
		return false

func changeStatus(tilePos: Vector2i):
	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")
	tileMap.set_cell(0, tilePos, 0, Vector2i(status, type))
	if status >= 2:
		tilesOnFire.erase(tilePos)


func _on_timer_timeout():

	var futureTilesOnFire = []

	for t in tilesOnFire:
		var currentTile: TileData = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue
		
		doDamage(t)

		var neighbors : Array[Vector2i] = tileMap.get_surrounding_cells(t)

		for n in neighbors:
			var neighborTile: TileData = tileMap.get_cell_tile_data(0, n)

			if !neighborTile || neighborTile.get_custom_data("status") >= 2:
				continue

			if doDamage(n):
				futureTilesOnFire.append(n)

	tilesOnFire = tilesOnFire + futureTilesOnFire
