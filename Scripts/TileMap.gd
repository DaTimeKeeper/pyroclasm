extends TileMap

@export var curPosition: Vector2i

@onready var tileMap: TileMap = $"."

enum TILE_TYPES  {GRASS, BUSH, TRESS}
enum TILE_STATUS {GREEN, BURNING, BURNED, WET}

var startingFireTile = Vector2i(1,1)
var tilesOnFire      = [startingFireTile]

func _process(delta):
	pass
		
func doDamage(tilePosition:Vector2i):
	var tile : TileData = tileMap.get_cell_tile_data(0, tilePosition)
	var health 			= tile.get_custom_data("health")
	var type   			= tile.get_custom_data("type")

	tileMap.set_cell(0, tilePosition, 0, Vector2i(0, type), health)

	if (health - 1) == 0:
		return tilePosition

func _on_timer_timeout():

	var futureTilesOnFire = []

	for t in tilesOnFire:
		var currentTile = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue

		var neighbors : Array[Vector2i] = tileMap.get_surrounding_cells(t)

		for n in neighbors:
			var neighborTile = tileMap.get_cell_tile_data(0, n)

			if !neighborTile:
				continue
			
				futureTilesOnFire.append(doDamage(n))

	tilesOnFire = tilesOnFire + futureTilesOnFire
