extends TileMap

@onready var tileMap: TileMap = $"."

signal setScorce(points: int)
signal allFireOut(finalScore: int)
signal fireUpdated()

const wind = {"north":     Vector2i(-1,-1),
			  "northWest": Vector2i(0,-1),
			  "west":      Vector2i(1,-1),
			  "southWest": Vector2i(1,0),
			  "south":     Vector2i(1,1),
			  "southEast": Vector2i(0,1),
			  "east":      Vector2i(-1,1),
			  "northEast": Vector2i(-1,0)}

var windDir: Vector2i = wind["north"]

var startingFireTile = Vector2i(0,0)
var tilesOnFire      = [startingFireTile]
var score = 0


func _on_update_fire_timer_timeout():
	var futureTilesOnFire = []
	var tilesToErase = []

	if tilesOnFire.size() == 0: #Check End state
		allFireOut.emit(score)

	for t in tilesOnFire:
		var currentTile: TileData = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue

		var neighbors: Array[Vector2i] = getTileInWind(t)
		var isFirst: bool = true

		for n in neighbors:
			var neighborTile: TileData = tileMap.get_cell_tile_data(0, n)

			if !neighborTile || !neighborTile.get_custom_data("burnable") ||checkOnFire(n):
				continue
			if isFirst == true:
				doDamage(n)
				isFirst = false
			doDamage(n)
			if checkOnFire(n):
				futureTilesOnFire.append(n)


		doDamage(t)
		if checkOnFire(t) && tileMap.get_cell_tile_data(0, t).get_custom_data("status") == 2:
			tilesToErase.append(t)


	tilesOnFire = tilesOnFire + futureTilesOnFire
	for e in tilesToErase:
		tilesOnFire.erase(e)
		tileMap.erase_cell(1,e)
		score += 1

	setScorce.emit(score)
	fireUpdated.emit()

func doDamage(tilePos: Vector2i):
	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var nextHealth =  tile.get_custom_data("health") - 1
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")

	#TDOD: add water overshield check
	# If waterShield >0 damage that then continue else run below

	if nextHealth >= 0 && status < 2:
		if (nextHealth <= 0):
			tileMap.set_cell(0, tilePos, 0, Vector2i(status+1, type))
			if (status + 1 == 1 || status == 1) && !checkOnFire(tilePos):
				setOnfire(tilePos)
		else:
			tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), nextHealth)
			if status == 1 && !checkOnFire(tilePos):
				setOnfire(tilePos)


func checkOnFire(tilePos: Vector2i):

	if(tileMap.get_cell_tile_data(1, tilePos)):
		return true
	else:
		return false

func setOnfire(tilePos: Vector2i):
	tileMap.set_cell(1, tilePos, 1, Vector2i(0, 0))

func getTileInWind(tilePos: Vector2i):
	var dirList: Array[Vector2i] = []
	var listTiles: Array[Vector2i] = []

	match windDir:
		wind["north"]:
			dirList = [wind["north"], wind["northWest"], wind["northEast"]]
		wind["south"]:
			dirList = [wind["south"], wind["southWest"], wind["southEast"]]
		wind["west"]:
			dirList = [wind["west"], wind["southWest"],  wind["northWest"]]
		wind["east"]:
			dirList = [wind["east"], wind["southEast"], wind["northEast"]]
		wind["southWest"]:
			dirList = [wind["southWest"], wind["west"], wind["south"]]
		wind["southEast"]:
			dirList = [wind["southEast"], wind["east"], wind["south"]]
		wind["northWest"]:
			dirList = [wind["northWest"], wind["west"], wind["north"]]
		wind["northEast"]:
			dirList = [wind["northEast"], wind["east"], wind["north"]]

	for x in dirList:
		listTiles.append( x + tilePos)

	return listTiles
	
	
func getNearestFire(currentPosition: Vector2):
	var nearestFire: Vector2 = tileMap.map_to_local(tilesOnFire[0])
	var nearestDistance = currentPosition.distance_to(nearestFire)
	for t in tilesOnFire:
		var newDistance=currentPosition.distance_to(tileMap.map_to_local(t))
		if nearestDistance>newDistance:
			nearestFire=t
			nearestDistance=newDistance
	return nearestFire




