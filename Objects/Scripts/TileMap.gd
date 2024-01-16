extends TileMap

@export var spot : Vector2i

@onready var tileMap: TileMap =$"."
enum TILE_TYPES {GRASS, BUSH, TRESS}
enum TILE_STATUS { GREEN, BURNING, BURNED, WET}


var startingFireTile = Vector2i(1,1)
var tilesOnFire= [startingFireTile]


		



		
func _process(delta):
	pass
		
		
#func doDamage(tilePosition:Vector2i):
	#var tile : TileData=tileMap.get_cell_tile_data(tilePosition)
	#var health = tile.get_custom_data("health")
	#tileMap.set_cell(0,n,0,tile.texture_origin,health-1)
	#if health-1==0:
		#tileMap.set_cell(0,tilePosition,0,Vector2i(1,2),0)
		#return tilePosition



func _on_timer_timeout():
	var futureTilesOnFire=[]
	for t in tilesOnFire:
		var currentTile =tileMap.get_cell_tile_data(0,t)
		if currentTile:
			var neighbors : Array[Vector2i] = tileMap.get_surrounding_cells(t)
			for n in neighbors:
				var neighborTile =tileMap.get_cell_tile_data(0,n)
				if neighborTile:
					var neighborHealth = neighborTile.get_custom_data("health")
					var neighborType = neighborTile.get_custom_data("type")
					if neighborTile.get_custom_data("burnable"):
						tileMap.set_cell(0,n,0,Vector2(0,neighborType),neighborHealth)
						if neighborHealth-1==0:
							futureTilesOnFire.append(n)
	tilesOnFire=tilesOnFire+futureTilesOnFire
